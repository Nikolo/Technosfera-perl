#!/usr/bin/perl

# USAGE:
# * found
#     ./binary_search_good.pl 10
#     ./binary_search_good.pl 20
#     ./binary_search_good.pl 40
# * not found
#     ./binary_search_good.pl -1
#     ./binary_search_good.pl 35
#     ./binary_search_good.pl 100

use strict;
use warnings;

my @items = (0, 10, 20, 30, 40);
my $x = $ARGV[0];
die "Missing argument" unless defined $x;


my $range1 = 0;
my $range2 = $#items;
while ($range1 <= $range2) {
    my $pos = int(($range1 + $range2) / 2);
    if ($items[$pos] < $x) {
        $range1 = $pos+1;
    } elsif ($items[$pos] == $x) {
        print "Found: $x (position $pos)\n";
        exit;
    } else { # $items[$pos] > $x
        $range2 = $pos-1;
    }
}
print "Not found: $x\n";
exit 1;
