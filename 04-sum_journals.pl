#!/usr/bin/perl 
## Thu Feb 12 14:02:10 PST 2009
## Christopher neo@ctopher.me



use strict;
use DBI;
# change ip address to your db server
# Change username and password to your username and pass
my $dsn = "DBI:mysql:host=192.168.1.43;database=myjournals";
my $dbh = DBI->connect ($dsn, "___USERNAME___", "___PASSWORD___")
						or die "can not connect to server.\n";


my @list	= ();
my @dates	= ();





my $sth = $dbh->prepare( "SELECT * FROM data "); 
$sth->execute();

while (my @row = $sth->fetchrow_array()) {
	my $datedur = join('#', $row[1], $row[3], $row[4], $row[5]);
	push @list, $datedur;

	push @dates, $row[1];	



}

my $total = "0";
my $count = "0";
my $wc1		= "0";
my $wc2		= "0";



my $test1 = @list;

if ($test1 < "1") {

	print "No records in database!!\n";
	exit;

}



my %seen	= ();
my @uniq	= ();

foreach my $item (@dates) {

	unless ($seen{$item}) {

		$seen{$item} = 1;
		push(@uniq, $item);

#		print "$item\n";

	}

}

my $sum_Dates	= @uniq;

my $wpm1	= "0";


foreach my $entry (@list) {
	my ($date, $dur, $wc, $wpm) = split(/#/, $entry);
	my ($sec, $min) = split(/-/, $dur);


	$wc1 += $wc;	
	$total += $sec;
	$count++;


	$wpm1	+= $wpm;






}

my $wpm2	= $wpm1 / $count;	
my $var1 = $total / $count;
my $var2 = $var1 / 60;
my $var3	= $wc1 / $count;
my $sectomin = ($total / 60);









my $wordCount1	= commify($wc1);
# my $writeTime1	= commify($sectomin);
my $journalCnt	= commify($count);


my $c2			= sprintf("%.2f", $sectomin);
my $c3			= sprintf("%.2f", $var2);
my $c4			= sprintf("%.2f", $var3);
my $c5			= sprintf("%.2f", $wpm2);

my $c22			= commify($c2);


print "\n\n";
print "Connected\n";
print "Number of days in DB:\t$sum_Dates\n";
print "Number of journals:\t$journalCnt\n";
print "Total Word Count:\t$wordCount1\n";
# print "Total Write Time A:\t$sectomin\n";

if ($sectomin < "1440") {
	print "Total Write Time:\t$c22 minutes\n";
} else {
	my $c42	= ($c2 / "60") / "24";
	$c42 = sprintf("%.4f", $c42);
	print "Total Write Time:\t$c42 days\n";
}

# print "SETS::::: 1 Total write time:\t$c22 minutes\n";
print "The average is:\t\t$c3 minutes\n";
print "The average WC is:\t$c4\n";
print "The average WPM is:\t$c5\n";
print "\n\n";




sub commify {
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}






exit(0);



