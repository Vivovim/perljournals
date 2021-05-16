# perljournals
Perl Journals that use VIM

Requires MySQL database server. Uses perl DBI, and DBD::MySQL, also requires VIM.

Replace the username, password, hostname, and database to your local settings. Then everything should just work.

There should be .sql file to generate the tables in MySQL.

To write, run Write-it.pl, starts up in terminal and runs VIM in current terminal window. Write, save and quit vim, then everything is saved to the database.

requires write access to /tmp for the file to write to.

Enjoy!
