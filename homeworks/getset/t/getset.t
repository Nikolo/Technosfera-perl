package Local::GetterSetter::Test;

use strict;
use warnings;

use Test::More tests => 4;

use Local::GetterSetter qw(test_name another_test_name);

our $test_name = 2;
our $another_test_name = 'another 2';

is(get_test_name(), 2, 'get');
is(get_another_test_name(), 'another 2', 'get another');

set_test_name(42);
set_another_test_name(7);

is($test_name, 42, 'set');
is($another_test_name, 7, 'set another');
