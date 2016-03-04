use strict;
use warnings;

use Test::More tests => 5;

use Local::Iterator::Array;
use Local::Iterator::Concater;

my $iterator = Local::Iterator::Concater->new(
    iterators => [
        Local::Iterator::Array->new(array => [1, 2]),
        Local::Iterator::Array->new(array => [3, 4]),
        Local::Iterator::Array->new(array => [5, 6]),
    ],
);

my ($next, $end);

($next, $end) = $iterator->next();
is($next, 1, 'next value');
ok(!$end, 'not end');

is_deeply($iterator->all(), [2, 3, 4, 5, 6], 'all');

($next, $end) = $iterator->next();
is($next, undef, 'no value');
ok($end, 'end');
