use strict;
use warnings;

use Test::More tests => 8;

use Local::Reducer::Sum;
use Local::Source::Array;

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

my $diff_reducer = Reducer::MaxDiff->new(
    top => 'received',
    bottom => 'sended',
    source => Source::Text->new(text =>"sended:1024,received:2048\nsended:2048,received:10240"),
    row_class => 'Local::Row::Simple',
);

my $sum_result;
my $diff_result;

$sum_result = $sum_reducer->reduce_n(1);
is($sum_result, 1, 'sum reduced 1');
is($sum_reducer->reduced, 1, 'sum reducer saved');

$sum_result = $sum_reducer->reduce_all();
is($sum_result, 6, 'sum reduced all');
is($sum_reducer->reduced, 6, 'sum reducer saved at the end');

$diff_result = $diff_reducer->reduce_n(1);
is($diff_result, 1024, 'diff reduced 1024');
is($diff_reducer->reduced, 1024, 'diff reducer saved');

$diff_result = $diff_reducer->reduce_all();
is($diff_result, 8192, 'diff reduced all');
is($diff_reducer->reduced, 8192, 'diff reducer saved at the end');
