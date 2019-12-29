#!/usr/bin/perl -w
## Thu Feb 12 14:02:10 PST 2009
## Christopher ctopher@mac.com



use strict;
use Time::Local;
# use Date::Calc qw(Day_of_Year);

use DBI;
# change ip address to your db server ip address. change username and password
my $dsn = "DBI:mysql:host=192.168.1.43;database=myjournals";
my $dbh = DBI->connect ($dsn, "___USERNAME___", "___PASSWORD___")
						or die "can not connect to server.\n";


print "Weekly Report on Journals to Date:\n";
my $week_sum = "0";
my $week_cnt = "0";
my $week_wc1 = "0";

my @wc_sums		= ();

# the time functions for the app.
my ($sec, $min, $hour, $DAY, $MONTH, $YEAR, $YDAY) = (localtime)[0,1,2,3,4,5,7];


my @days = ( 1 .. 7 );
my $set = time;

$set = ($set + "86400"); # sick hack to make today show.

foreach my $day (@days) {
	$set = ($set - "86400");
	my ($sc, $mn, $hr, $dy, $mt, $yr) = localtime($set);

	my $Sept = $mt + 1;
	my $twt11 = $yr + 1900; 
	my $date = $Sept . "-" . $dy . "-" . $twt11;


	&PrintEm($date);
	

}






sub PrintEm {

	my $count = "";
	my $time_spent = "0";
	my $date = shift;
	my $wc1		= "0";


		my $sth = $dbh->prepare( "SELECT date, time, duration, subject, wc FROM data WHERE date = '$date'"); 
		$sth->execute();


	print "$date####################################################\n";


		while (my @row = $sth->fetchrow_array()) {


			# print "\tTime: $row[1]\tSubject: $row[3]\n";

			my $time = $row[2];
			my ($sec, $min) = split(/-/, $time);
			$time_spent += $sec;

			$count++;
			$week_cnt++;



			$wc1	+= $row[4];

		






		}

	
	my $Ttime = ($time_spent / "60") / "60";

	$week_sum += $Ttime;


	print "Hours per day: $Ttime\tTotal Journals for day: $count\n";
	print "Total Word Count: $wc1\n\n\n";

	push @wc_sums, $wc1;

	}

my $sum	= "0";

foreach my $wc (@wc_sums) {

	$sum += $wc;


	

}

my $average1	= $sum / $week_cnt;




print "Sum of Hours for Week: $week_sum\n";
print "Sum of entries for Week: $week_cnt\n";
print "Average wc: $average1\n";



exit(0);



