#!/usr/bin/python3
import os
import requests
import pymysql
from pymysql.cursors import DictCursor


# change your username and password, and host name.
# change the system prompt to put your name into it.
# ----------------------------
# Config (prefer env vars)
# ----------------------------
MYSQL_HOST = os.getenv("JOURNAL_DB_HOST", "localhost")
MYSQL_PORT = int(os.getenv("JOURNAL_DB_PORT", "3306"))
MYSQL_USER = os.getenv("JOURNAL_DB_USER", "__USERNAME__")
MYSQL_PASS = os.getenv("JOURNAL_DB_PASS", "__PASSWORD__")
MYSQL_DB   = os.getenv("JOURNAL_DB_NAME", "journals")

# Your journal table name (set this correctly)
JOURNAL_TABLE = os.getenv("JOURNAL_TABLE", "data")  # <-- change if needed

LMSTUDIO_URL = os.getenv("LMSTUDIO_URL", "http://127.0.0.1:1234/v1/chat/completions")
MODEL_NAME   = os.getenv("LMSTUDIO_MODEL", "local-model")
PROMPT_VERSION = os.getenv("PROMPT_VERSION", "v1")

SYSTEM_PROMPT = (
    "You are [your name here] nightly journal companion. Respond with warmth, clarity, and respect. "
    "Reflect back what you heard using concrete details from the entry (quote short phrases if helpful). "
    "Name 2–4 themes you notice. Name at least one win (even small). "
    "Validate difficulties without dramatizing. Offer one gentle practical suggestion for tomorrow. "
    "Keep it concise (150–300 words), thoughtful, and not cheesy. "
    "Do not mention you are an AI. Do not give medical/legal advice."
)

def db_connect():
    return pymysql.connect(
        host=MYSQL_HOST,
        port=MYSQL_PORT,
        user=MYSQL_USER,
        password=MYSQL_PASS,
        database=MYSQL_DB,
        charset="utf8mb4",
        cursorclass=DictCursor,
        autocommit=True,
    )

def fetch_latest_entry(conn):
    # Most reliable: recid is auto_increment, so highest recid == most recent insert
    sql = f"""
        SELECT recid, date, time, subject, body
        FROM {JOURNAL_TABLE}
        ORDER BY recid DESC
        LIMIT 1
    """
    with conn.cursor() as cur:
        cur.execute(sql)
        return cur.fetchone()

def reflection_exists(conn, recid):
    sql = """
        SELECT 1
        FROM journal_ai_reflections
        WHERE journal_recid=%s AND prompt_version=%s
        LIMIT 1
    """
    with conn.cursor() as cur:
        cur.execute(sql, (recid, PROMPT_VERSION))
        return cur.fetchone() is not None

def blob_to_text(blob_value) -> str:
    """
    PyMySQL returns BLOB as bytes. Convert to UTF-8 text.
    If your journal body is not UTF-8, we fall back gracefully.
    """
    if blob_value is None:
        return ""
    if isinstance(blob_value, (bytes, bytearray)):
        try:
            return blob_value.decode("utf-8")
        except UnicodeDecodeError:
            # Fallback: keep readable characters, replace the rest
            return blob_value.decode("utf-8", errors="replace")
    return str(blob_value)

def call_lmstudio(journal_text: str) -> str:
    payload = {
        "model": MODEL_NAME,
        "temperature": 0.7,
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": journal_text},
        ],
    }
    r = requests.post(LMSTUDIO_URL, json=payload, timeout=180)
    r.raise_for_status()
    data = r.json()
    return data["choices"][0]["message"]["content"].strip()

def save_reflection(conn, recid: int, reflection_text: str):
    sql = """
        INSERT INTO journal_ai_reflections (journal_recid, model, prompt_version, reflection)
        VALUES (%s, %s, %s, %s)
    """
    with conn.cursor() as cur:
        cur.execute(sql, (recid, MODEL_NAME, PROMPT_VERSION, reflection_text))

def main():
    conn = db_connect()

    entry = fetch_latest_entry(conn)
    if not entry:
        print("No journal entries found.")
        return

    recid = entry["recid"]

    if reflection_exists(conn, recid):
        print(f"Reflection already exists for recid {recid} ({PROMPT_VERSION}).")
        return

    body_text = blob_to_text(entry["body"]).strip()
    if not body_text:
        print(f"recid {recid} has an empty body.")
        return

    # Optional: include subject/date/time as context header
    header = f"Date: {entry.get('date','')} Time: {entry.get('time','')}\nSubject: {entry.get('subject','')}\n\n"
    journal_text = header + body_text

    reflection = call_lmstudio(journal_text)
    save_reflection(conn, recid, reflection)

    print(f"Saved reflection for recid {recid}.")

if __name__ == "__main__":
    main()
