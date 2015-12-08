use strict;
use warnings;

use Test::More tests => 6;

use Local::Iterator::Array;

my $array = [1, undef, 3];
my $iterator = Local::Iterator::Array->new(array => $array);

my ($next, $end);

($next, $end) = $iterator->next();
is($next, 1, 'next value');
ok(!$end, 'not end');

is_deeply($iterator->all(), [undef, 3], 'all');

($next, $end) = $iterator->next();
is($next, undef, 'no value');
ok($end, 'end');

is_deeply($array, [1, undef, 3], 'array is not corrupted');
