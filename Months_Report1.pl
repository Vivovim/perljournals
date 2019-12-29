#!/usr/bin/perl -w
## Thu Feb 12 14:02:10 PST 2009
## Christopher ctopher@mac.com



use strict;
use Time::Local;
# use Date::Calc qw(Day_of_Year);

use DBI;

# change ip address to your db server
# Change username and password to your credits
my $dsn = "DBI:mysql:host=192.168.1.43;database=myjournals";
my $dbh = DBI->connect ($dsn, "___USERNAME___", "___PASSWORD___")
						or die "can not connect to server.\n";


print "Monthly Report on Journals to Date:\n";


my $week_sum = "0";
my $week_cnt = "0";
my $week_wc1 = "0";

my $monthly_sum	= "0";
my $monthly_cnt	= "0";
my $monthly_wc1	= "0";






my @wc_sums		= ();

# the time functions for the app.
my ($sec, $min, $hour, $DAY, $MONTH, $YEAR, $YDAY) = (localtime)[0,1,2,3,4,5,7];


my $sth = $dbh->prepare( "SELECT date FROM data" );
	$sth->execute();


my @dates_set = ();

while (my @set = $sth->fetchrow_array()) {

		push @dates_set, $set[0];


}


my %seen	= ();
my @uniq	= ();


my @Months_Set	= ();
my %M_Seen		= ();
my @m_Uniq		= ();

# test setup...

my @january		= ();
my @febuary		= ();
my @march		= ();
my @april		= ();
my @may			= ();
my @june		= ();
my @july		= ();
my @august		= ();
my @september	= ();
my @october		= ();
my @november	= ();
my @december	= ();



foreach my $item (@dates_set) {


	my ($m_Set, $d_Set, $Y_Set) = split(/-/, $item);

	push @Months_Set, $m_Set;


	if ($m_Set == "1") { push @january, $item; }
	if ($m_Set == "2") { push @febuary, $item; }
	if ($m_Set == "3") { push @march, $item; }
	if ($m_Set == "4") { push @april, $item; }
	if ($m_Set == "5") { push @may, $item; }
	if ($m_Set == "6") { push @june, $item; }
	if ($m_Set == "7") { push @july, $item; }
	if ($m_Set == "8") { push @august, $item; }
	if ($m_Set == "9") { push @september, $item; }
	if ($m_Set == "10") { push @october, $item; }
	if ($m_Set == "11") { push @november, $item; }
	if ($m_Set == "12") { push @december, $item; }



	unless ($seen{$item}) {

		$seen{$item}	= "1";
		push @uniq, $item;
	}


}

my $january	= @january;
my $febuary	= @febuary; 
my $march	= @march;
my $april	= @april;
my $may		= @may; 
my $june	= @june;
my $july	= @july;
my $august	= @august;
my $september = @september;
my $october		= @october;
my $november	= @november;
my $december	= @december;



























foreach my $item (@uniq) {

#	print "$item\n";
	&PrintEm($item);

}













sub PrintEm {

	my $count = "";
	my $time_spent = "0";
	my $date = shift;
	my $wc1		= "0";




	# print "$M_month\n";




		my $sth = $dbh->prepare( "SELECT date, time, duration, subject, wc FROM data WHERE date = '$date'"); 
		$sth->execute();


	print "$date - ####################################################\n";


		while (my @row = $sth->fetchrow_array()) {


			# print "\tTime: $row[1]\tSubject: $row[3]\n";

			my $time = $row[2];
			my ($sec, $min) = split(/-/, $time);
			$time_spent += $sec;

			$count++;
			$week_cnt++;



			$wc1	+= $row[4];

#			my ($M_1, $D_1, $Y_1) = split(/-/, $row[0]);
#				if ($M_1 == "1") { $january++;}
#				if ($M_1 == "2") { $febuary++;}
#				if ($M_1 == "3") { $march++;}
#				if ($M_1 == "4") { $april++;}
#				if ($M_1 == "5") { $may++;}
#				if ($M_1 == "6") { $june++;}
#				if ($M_1 == "7") { $july++;}
#				if ($M_1 == "8") { $august++;}
#				if ($M_1 == "9") { $september++;}
#				if ($M_1 == "10") { $october++;}
#				if ($M_1 == "11") { $november++;}
#				if ($M_1 == "12") { $december++;}






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





print "Monthly Report: \n";
print "Month:	 #Journal Count\n";


print "January:   $january\n";
print "Febuary:   $febuary\n";
print "March:     $march\n";
print "April:     $april\n";
print "May:       $may\n";
print "June:      $june\n";
print "July:      $july\n";
print "August     $august\n";
print "September: $september\n";
print "October:   $october\n";
print "November:  $november\n";
print "December:  $december\n";

print "\n\n\n";


print "Sum of Hours: $week_sum\n";
print "Sum of entries: $week_cnt\n";
print "Average wc: $average1\n\n\n";

print "#------------------- end report\n\n\n\n";



exit(0);



