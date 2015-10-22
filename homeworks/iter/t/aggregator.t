use strict;
use warnings;

use Test::More tests => 5;

use Local::Iterator::Array;
use Local::Iterator::Aggregator;

my $iterator = Local::Iterator::Aggregator->new(
    iterator => Local::Iterator::Array->new(array => [1, 2, 3, 4, 5, 6, 7]),
    chunk_length => 2,
);

my ($next, $end);

($next, $end) = $iterator->next();
is_deeply($next, [1, 2], 'full chunk');
ok(!$end, 'not end');

is_deeply(
    $iterator->all(),
    [[3, 4], [5, 6], [7]],
    'all'
);

($next, $end) = $iterator->next();
is($next, undef, 'no value');
ok($end, 'end');
