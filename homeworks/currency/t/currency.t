use strict;
use warnings;

use Test::More tests => 3;

use Local::Currency qw(set_rate);

set_rate({
    'rur' => 1,
    'usd' => 60,
    'eur' => 70,
});

is(Local::Currency::rur_to_rur(42), 42, 'trivial');
is(Local::Currency::rur_to_usd(120), 2, 'cheap to expensive');
is(Local::Currency::eur_to_usd(42), 49, 'expensive to cheap');
