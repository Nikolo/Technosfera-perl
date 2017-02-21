#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use Test::More;
do "$FindBin::Bin/../bin/01.pl" or die "Can't open $FindBin::Bin/../bin/01.pl: $!";

my @TESTS = (
    [ [0, 1, 2], 'No solution!' ],
    [ [-2, 0, 128], '-8, 8' ], 
    [ [12, 9, 0], '0, -0.75' ],
    [ [1, 2, -3], '1, -3' ],
    [ [5, 6, 7], 'No solution!' ],
);

plan tests => scalar(@TESTS);

$| = 1;

my $stdout;
close STDOUT;
open STDOUT, '>', \$stdout or die "Can't open STDOUT: $!";

foreach my $item (@TESTS) {
  run(@{$item->[0]});
}

my @result = split "\n", $stdout;
for (my $i = 0; $i < scalar(@TESTS); $i++) {
    my $test_name = join ', ', @{$TESTS[$i]->[0]};
    is($result[$i], $TESTS[$i]->[1], $test_name);
}

1;
