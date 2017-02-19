#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use Test::More;
do "$FindBin::Bin/../bin/05.pl" or die "Can't open $FindBin::Bin/../bin/05.pl: $!";

my @TESTS = (
    [ ['e#ab#c1de#ab#ab#cf', 'ab' ], '3'],
    [ ['e#ab#c1de#ab#ab#cf#ab', 'ab' ], '4'],
    [ ['e#abab#deab', 'ab' ], '3'],
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
