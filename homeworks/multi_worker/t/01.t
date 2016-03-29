#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 7;
use Test::TCP;
use Local::App::GenCalc;
use Local::App::ProcessCalc;
use Local::App::Calc;
use List::Util qw/min max/;

my $server = Test::TCP->new(
    code => sub {
        my $port = shift;
        Local::App::GenCalc::start_server($port);
    },
);

my $server_calc = Test::TCP->new(
    code => sub {
        my $port = shift;
        Local::App::Calc::start_server($port);
    },
);

sub get_status {
    open(my$fh, '<', $Local::App::ProcessCalc::status_file) or return {};
    my $json = <$fh>;
    return JSON::XS::decode_json($json);
};

sleep(5);

my $jobs = Local::App::GenCalc::get(1);
is(scalar(@$jobs), 1, "local get");
$jobs = Local::App::ProcessCalc::get_from_server($server->port, 100);
is(scalar(@$jobs), 100, "server get");
my $ret = Local::App::ProcessCalc::multi_calc(10, $jobs, $server_calc->port);
is(scalar(@$ret), scalar(@$jobs), "return values");

my $struct = get_status();

my $status;
my $sum = 0;
my $cnt_worker = 0;
my $min;
my $max;
for (keys %$struct) {
    $status .= $_." ".$struct->{$_}->{status}.$/ if $struct->{$_}->{status} ne 'done'; 
    $sum += $struct->{$_}->{cnt};
    $cnt_worker++;
    $min = $max = $struct->{$_}->{cnt} unless defined $min;
    $min = min($min, $struct->{$_}->{cnt});
    $max = max($max, $struct->{$_}->{cnt});
}

is($status, undef, "worker status");
is($sum, scalar(@$jobs), "worker sum");
is($cnt_worker, int((scalar(@$jobs)+9)/10), "worker cnt");
is($max-$min, 0, "Diff jobs on worker");
