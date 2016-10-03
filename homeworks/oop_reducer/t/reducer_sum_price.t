use strict;
use warnings;

use Test::More tests => 4;

use Local::Reducer::SumPrice;
use Local::Source::Array;

my $reducer = Local::Reducer::SumPrice->new(
    source => Local::Source::Array->new(array => [
        '{"price": 1}',
        '{"price": 2}',
        '{"price": 3}',
    ]),
    row_class => 'Local::Row::JSON',
    initial_value => 0,
);

my $result;

$result = $reducer->reduce_n(1);
is($result, 1, 'reduced 1');
is($reducer->reduced, 1, 'reduced saved');

$result = $reducer->reduce_all();
is($result, 6, 'reduced all');
is($reducer->reduced, 6, 'reduced saved at the end');
