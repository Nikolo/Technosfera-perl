use strict;
use warnings;

use Test::More tests => 5;

use Local::Iterator::Array;

my $iterator = Local::Iterator::Array->new(array => [1, undef, 3]);

my ($next, $end);

($next, $end) = $iterator->next();
is($next, 1, 'next value');
ok(!$end, 'not end');

is_deeply($iterator->all(), [undef, 3], 'all');

($next, $end) = $iterator->next();
is($next, undef, 'no value');
ok($end, 'end');
