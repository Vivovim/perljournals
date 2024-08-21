#!/usr/bin/perl -w
## Thu Nov 12 12:59:31 MST 2015
## Christopher neo@ctopher.me

use strict;


###########
## edit line 34 to set the exact record for start of prints.

use DBI;
my $dsn = "DBI:mysql:host=192.168.1.43;database=myjournals";
my $dbh = DBI->connect ($dsn, "___USERNAME___", "___PASSWORd___")
                                                or die "can not connect to server.\n";
print "Connected\n";


my $sth = $dbh->prepare( "SELECT recid FROM data" );
$sth->execute();

my @recids	= ();

while (my @row = $sth->fetchrow_array()) {

	my $rec1	= $row[0];

	push @recids, $rec1;
}


#### Set these as needed to your needs... should be year & recid
my $year	= "2017-2";

my $file = "3201";

mkdir("Journals_each");



foreach my $rec (@recids) {
#	print "$rec\n";

# my $file0	= $file . "\." . $year . ".txt";

my $file0	= $file . ".txt";

open (FO, ">>Journals_each/$file0") || die "Couldn't open $file0 $!";



my $sth = $dbh->prepare( "SELECT * FROM data WHERE recid='$rec'" );
$sth->execute();


while (my @row = $sth->fetchrow_array()) {

#	print FO "$row[0], $row[1], $row[2]\n";

 print FO "******************************************42bitpi\n";


                        print FO "Record: $row[0]\nDate: $row[1]\nTime: $row[2]\nDuration: $row[3] :seconds/-/minutes\nWC: $row[4]\nWPM: $row[5]\nCategory:  $row[6]\nSubject: $row[7]\nJournal Body:\n$row[8]\n\n";

                print FO "##########################################42bitpi\n\n\n";




}


close(FO);

$file++;









}

exit(0);















