#!/usr/bin/perl 
## Thu Feb 12 14:02:10 PST 2009
## Christopher ctopher@mac.com



use strict;
use DBI;
# change ip address to your db server. Change username and password
# SEE line 27 to change the path to your home directory.
my $dsn = "DBI:mysql:host=192.168.1.43;database=myjournals";
my $dbh = DBI->connect ($dsn, "___USERNAME___", "___PASSWORD___")
						or die "can not connect to server.\n";
print "Connected\n";



my $time = time;

my ($MONTHDAY, $YEAR, $WEEKDAY, $YEARDAY) = (localtime $time)[3,5,6,7];
$YEARDAY += "1";

$YEAR = $YEAR + "1900";



# Change path to your current home directory. $HOME
# only change:  *************** /do not edit past here.
	my $fileo = "/usr/home/alex/$YEARDAY.$MONTHDAY.0.$YEAR.journals.txt";
	open (FO, ">>$fileo") || die "Couldnt open $fileo $!";



my $head	= "42bitpi******************************************42BitPI\n";
my $foot	= "42bitpi##########################################42bitpi\n\n\n";





my $answer = "All";



	&PrintEm($answer);

sub PrintEm {

		my $catagory = shift;





		my $sth = $dbh->prepare( "SELECT * FROM data ORDER BY recid"); 
		$sth->execute();

		while (my @row = $sth->fetchrow_array()) {




		print FO "$head";


			print FO "Record: $row[0]\nDate: $row[1]\nTime: $row[2]\nDuration: $row[3] :seconds/-/minutes\nWC: $row[4]\nWPM: $row[5]\nCategory: $row[6]\nSubject: $row[7]\nJournal Body:\n$row[8]\n";




		print FO "$foot";



	}
}







my @list = ();
my $sth = $dbh->prepare( "SELECT * FROM data "); 
$sth->execute();

while (my @row = $sth->fetchrow_array()) {
	my $datedur = join('#', $row[1], $row[3], $row[4]);
	push @list, $datedur;
}

my $total = "0";
my $count = "0";
my $wc1		= "0";


foreach my $entry (@list) {
	my ($date, $dur, $wc) = split(/#/, $entry);
	my ($sec, $min) = split(/-/, $dur);


	$total += $sec;

	$wc1	+= $wc;

	$count++;
}

my $var1 = $total / $count;
my $var2 = $var1 / 60;


my $sectomin = ($total / 60);

print FO "Journal write time equals: $sectomin minutes\n";
print FO "Total # of journals is: $count\n";
print FO "Total Word Count: $wc1\n";

print FO "The average is: $var2 minutes\n";

print "$fileo\n";
print "it worked.\n\n";

exit(0);


