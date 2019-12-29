#!/usr/bin/perl -w
## Thu Sep  1 16:45:03 PDT 2011
## Christopher ctopher@mac.com



use strict;


my @zeros = ( 0 ) x 100000;

my @ones = ( 1 ) x 150000;


my @set = ();

push @set, (@zeros, @ones);




# fisher_yates_shuffle( \@array ) : generate a random permutation
# of @array in place
sub fisher_yates_shuffle {
    my $array = shift;
    my $i;
    for ($i = @$array; --$i; ) {
        my $j = int rand ($i+1);
        next if $i == $j;
        @$array[$i,$j] = @$array[$j,$i];
    }
}

fisher_yates_shuffle( \@set );    # permutes @array in place

print "@set\n";





