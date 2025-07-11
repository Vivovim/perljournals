#!/usr/bin/perl -w
## Thu Oct 17 23:11:49 MST 2024
## Christopher neo@ctopher.me 

use strict;


use DBI;




my $dsn = "DBI:mysql:host=localhost;database=journals";
my $dbh = DBI->connect ($dsn, "root", "__PASSWORD__")
                                                or die "can not connect to server.\n";

our $table = "";

&TablesS();

sub TablesS {

my %tables = ();




my $sth = $dbh->prepare( "SHOW TABLES"); 
$sth->execute();

my $tablesc = "0";

while (my @row = $sth->fetchrow_array()) {

        my $tb = $row[0];

        $tables{$tablesc} = $tb;
        $tablesc++;

}


my @keys = keys %tables;

my @sorted = sort {$a <=> $b} @keys;

foreach my $key (@sorted) {

        my $value = $tables{$key};

        print "$key: $value\n";

}

print "Enter Table To Search: ";

my $tablesearch = <STDIN>;

chomp($tablesearch);


my $xtable = $tables{$tablesearch};



$table = $xtable;



&SearchSet();


}















sub SearchSet {

print "Enter your search term: (x52 to exit)\n";
print "Type x101 to change tables \n";
print "\>Search: ";
my $term = <STDIN>;

chomp($term);


if ($term eq "x101") {
	&TablesS();

}

if ($term eq "x52") {
	print "Goodbye. . .\n";
	exit(0);
}

&PrintEm($term);

}



print "Connected to todays posts\n";


# the time functions for the app.
my ($sec, $min, $hour, $DAY, $MONTH, $YEAR) = (localtime)[0,1,2,3,4,5];

# print "$DAY\n";


my $rmonth = $MONTH + 1;
my $ryear = $YEAR + 1900; 
my $date = $rmonth . "\/" . $DAY . "\/" . $ryear;

my $count = "";

my $time_spent = "0";






my $wc1         = "0";


sub PrintEm {

	my $search = shift;
	my $count = 0;


	my %handles = ();


my $head        = "000000000000000000000010000000000000000000000000000000000000000042bitpi\n";
my $foot        = "000000000000000000000011111111111111111111111111111111111111111142bitpi\n";

                my $sth = $dbh->prepare( "SELECT * FROM `$table` WHERE body LIKE '%$search%' ORDER BY recid"); 
                $sth->execute();




                print "$head";

open(my $fh2, '|-', 'more') or die "Can't open pipe to more: $!";


                while (my @row = $sth->fetchrow_array()) {
                        # print "################\n";
#						print "$row[2]\n";

						print $fh2 "$count\t";

                        print $fh2 "recid: $row[0]\t";
                        print $fh2 "$row[7]\t\t";
						print $fh2 "$row[1]\n";

						$handles{$count} = $row[0];

						$count++;

						}


						if ($count <= 0) {
							close($fh2);
							&SearchSet();
						}



close($fh2);

print "$foot\n";


print "Enter the journal number to search: ";

	my $entry = <STDIN>;

	chomp($entry);

	if ($entry eq "exit") {
		print "Goodbye. . .\n";

		exit(0);
	}

my $xterm = $handles{$entry};


my $sth2 = $dbh->prepare( "SELECT * FROM `$table` WHERE recid = '$xterm' Limit 1"); 
$sth2->execute();

open(my $fh, '|-', 'more') or die "Can't open pipe to more: $!";


                while (my @row = $sth2->fetchrow_array()) {
                        # print "################\n";
#						print "$row[2]\n";

						print $fh "RECID: $row[0]\n";
						print $fh "Date: $row[1]\n";
                        print $fh "subject: $row[7]\n";
                        print $fh "body: $row[8]\n\n";


						}
close($fh);



&SearchSet();



        }

















exit(0);



