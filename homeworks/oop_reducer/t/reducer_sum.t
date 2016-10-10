use strict;
use warnings;

use Test::More tests => 4;

use Local::Reducer::Sum;
use Local::Source::Array;
use Local::Row::JSON;

my $sum_reducer = Local::Reducer::Sum->new(
    field => 'price',
    source => Local::Source::Array->new(array => [
        '{"price": 1}',
        '{"price": 2}',
        '{"price": 3}',
    ]),
    row_class => 'Local::Row::JSON',
    initial_value => 0,
);

my $sum_result;

$sum_result = $sum_reducer->reduce_n(1);
is($sum_result, 1, 'sum reduced 1');
is($sum_reducer->reduced, 1, 'sum reducer saved');

$sum_result = $sum_reducer->reduce_all();
is($sum_result, 6, 'sum reduced all');
is($sum_reducer->reduced, 6, 'sum reducer saved at the end');
