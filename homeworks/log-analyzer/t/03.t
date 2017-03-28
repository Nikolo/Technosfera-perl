#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use Test::More tests => 4;
use FindBin;
use Symbol 'gensym';
use IPC::Open3;

sub test_file {
    my ($name, $file, $output) = @_;

    my $outf = gensym;
    my $errf = gensym;
    my $pid = open3(undef,$outf,$errf, $^X, "$FindBin::Bin/../bin/analyze.pl","$FindBin::Bin/../$file");
    waitpid( $pid, 0 );
    my $out = do { local $/; <$outf> };
    my $err = do { local $/; <$errf> };
    if ($? >> 8) {
        fail "Failed to run script";
        diag $err;
        exit 255;
    }

    ok !length($err),"Script has warnings";
    diag $err if length $err;

    my @template = split /\n/,$output;
    my @result = split /\n/, $out;

    for (0..$#template) {
        is $result[$_], $template[$_], "row $_";
    }

    #is($out, $output, $name);
}

test_file 'basic', "test-03.log", <<OUTPUT;
IP	count	avg	data	200	302
total	40	10.00	10181	10181	6
195.178.213.236	40	10.00	10181	10181	6
OUTPUT
