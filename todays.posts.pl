#!/usr/bin/perl 
## Thu Feb 12 14:02:10 PST 2009
## Christopher neo@ctopher.me



use strict;
use DBI;

# Change IP ADDRESS, username and password
my $dsn = "DBI:mysql:host=192.168.1.43;database=myjournals";
my $dbh = DBI->connect ($dsn, "___USERNAME___", "___PASSWORD___")
						or die "can not connect to server.\n";
print "Connected to todays posts\n";


# the time functions for the app.
my ($sec, $min, $hour, $DAY, $MONTH, $YEAR) = (localtime)[0,1,2,3,4,5];

# print "$DAY\n";


my $rmonth = $MONTH + 1;
my $ryear = $YEAR + 1900; 
my $date = $rmonth . "-" . $DAY . "-" . $ryear;

my $count = "";

my $time_spent = "0";


my $head	= "42bitpi******************************************42BitPI\n";
my $foot	= "42bitpi##########################################42bitpi\n\n\n";




my $wc1		= "0";

&PrintEm();

sub PrintEm {



		my $sth = $dbh->prepare( "SELECT recid, date, time, duration, wc, wpm, subject FROM data WHERE date = '$date'"); 
		$sth->execute();


		print "$head";



		while (my @row = $sth->fetchrow_array()) {



			# print "################\n";
			print "Recid: $row[0]\n";

			print "Date: $row[1]\nTime: $row[2]\nDuration: $row[3]\nSubject: $row[6]\nWC: $row[4]\nWPM: $row[5]\n\n";

			my $time = $row[3];
			my ($sec, $min) = split(/-/, $time);
			$time_spent += $sec;

			$wc1	+= $row[4];

			$count++;


		}
	}
		print "$foot";



my $Ttime = ($time_spent / "60") / "60";



print "Total Journals Today: $count\n";
print "Total Time in hours: $Ttime\n";
print "Total WC Today: $wc1\n\n\n";



exit(0);



