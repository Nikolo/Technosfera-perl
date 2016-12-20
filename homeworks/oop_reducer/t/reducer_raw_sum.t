use strict;
use warnings;

use Test::More tests => 6;

use Local::Reducer::Sum;
use Local::Source::Array;
use Local::Row::Raw;

my $sum_reducer = Local::Reducer::Sum->new(
    field => 'value',
    source => Local::Source::Array->new(array => [ "invalid", -1..6, "bad", 3.14, "5.10.1" ]),
    row_class => 'Local::Row::Raw',
    initial_value => 5,
);

my $sum_result;

$sum_result = $sum_reducer->reduce_n(3);
is($sum_result, 4, 'sum reduced 4');
is($sum_reducer->reduced, $sum_result, 'sum reducer saved');

$sum_result = $sum_reducer->reduce_n(2);
is($sum_result, 7, 'sum reduced 11');
is($sum_reducer->reduced, $sum_result, 'sum reducer saved');

$sum_result = $sum_reducer->reduce_all();
is($sum_result, 28.14, 'sum reduced all 28.14');
is($sum_reducer->reduced, $sum_result, 'sum reducer saved at the end');
