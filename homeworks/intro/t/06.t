#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use Test::More;
do "$FindBin::Bin/../bin/06.pl" or die "Can't open $FindBin::Bin/../bin/06.pl: $!";

my @TESTS = (
    [ 'Hello world!',  257, 'Khoor#zruog$'],
    [ 'Howto learn perl?', 127, 'Howto learn perl?'],
    [ 'Perl is simple', 2, 'Rgtn"ku"ukorng'],
);

plan tests => scalar(@TESTS) * 2;

$| = 1;

foreach my $item (@TESTS) {

    my $stdout;
    close STDOUT;
    open STDOUT, '>', \$stdout or die "Can't open STDOUT: $!";
    my ($str, $key, $encoded_str) = @$item;
    encode($str, $key);
    decode($encoded_str, $key);

    my @result = split "\n", $stdout;
    is(shift(@result), $encoded_str, $str);
    is(shift(@result), $str, $encoded_str);
}

1;
