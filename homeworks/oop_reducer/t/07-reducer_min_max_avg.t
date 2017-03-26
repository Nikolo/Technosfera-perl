#!/usr/bin/env perl

use strict;
use warnings;
use FindBin; use lib "$FindBin::Bin/../lib";
use Test::More;

do {
    local $TODO = "optional";
    use_ok 'Local::Reducer::MinMaxAvg';
} or do {
    diag "MinMaxAvg is not implemented but recommended";
    done_testing();
    exit;
};

local $TODO = "MinMaxAvg is optional";

use Local::Source::Array;
use Local::Row::JSON;

my $reducer = Local::Reducer::MinMaxAvg->new(
    field => 'price',
    source => Local::Source::Array->new(array => [
        '{"price": 1}',
        '{"price": 2}',
        '{"price": 3}',
        '{"price": 4}',
        '{"price": 8}',
        '{"price": 15}',
        '{"price": 16}',
    ]),
    row_class => 'Local::Row::JSON',
    initial_value => 0,
);

my $try = $reducer->reduce_n(3);
is $try->get_min, 1, 'min';
is $try->get_max, 3, 'max';
is $try->get_avg, 2, 'avg';

$try = $reducer->reduce_all();
is $try->get_min, 1, 'min';
is $try->get_max, 16, 'max';
is $try->get_avg, 7, 'avg';

done_testing();
