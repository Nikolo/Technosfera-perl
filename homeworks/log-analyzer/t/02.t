#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use Test::More tests => 13;
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

test_file 'basic', "access.log.bz2", <<OUTPUT;
IP	count	avg	data	200	301	302	400	403	404	408	414	499	500
total	22343	544.95	7376153	1784662	1108	705	85	15469	11269	0	1	0	514
195.178.213.236	1575	38.41	390036	390036	146	248	0	0	1942	0	0	0	0
68.51.312.236	1519	37.05	541106	79715	15	31	0	0	1060	0	0	0	0
217.200.64.87	1287	32.17	568476	81813	1	0	0	1982	0	0	0	0	0
5.11.67.90	805	19.63	302124	49060	0	0	0	0	0	0	0	0	0
194.177.83.106	215	107.50	1940	331	0	0	0	0	0	0	0	0	0
163.146.22.45	162	5.40	26859	26859	0	0	0	0	2480	0	0	0	0
188.171.77.100	144	3.89	40033	7388	0	0	0	0	0	0	0	0	0
188.171.95.118	142	3.55	42425	7580	0	0	0	0	0	0	0	0	0
188.171.72.95	141	3.71	42429	7515	0	0	0	0	0	0	0	0	0
188.171.73.96	139	3.48	38998	7168	0	0	0	0	0	0	0	0	0
OUTPUT
