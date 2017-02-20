#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use Test::More;
do "$FindBin::Bin/../bin/04.pl" or die "Can't open $FindBin::Bin/../bin/04.pl: $!";

my @TESTS = (
    [ 0xffff0000, '16' ],
    [ 0x80000000, '31' ],
);

plan tests => scalar(@TESTS);

$| = 1;

my $stdout;
close STDOUT;
open STDOUT, '>', \$stdout or die "Can't open STDOUT: $!";

foreach my $item (@TESTS) {
  run($item->[0]);
}

my @result = split "\n", $stdout;
for (my $i = 0; $i < scalar(@TESTS); $i++) {
    my $test_name = sprintf "%x value", $TESTS[$i]->[0];
    is($result[$i], $TESTS[$i]->[1], $test_name);
}

1;
