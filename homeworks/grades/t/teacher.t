use strict;
use warnings;

use Test::More tests => 3;
use Test::DBIx::Class;

my $rs = Schema->resultset('Teacher');

$rs->create({first_name => 'Vadim', last_name => 'Pushtaev'});
$rs->create({first_name => 'Peter', last_name => 'Vadimov'});
$rs->create({first_name => 'Alex',  last_name => 'Pushtaev'});

my @found = $rs->search_by_name('vadim')->search(undef, {order_by => 'id'})->all();

is(scalar @found, 2, 'found size');
is($found[0]->first_name, 'Vadim', 'first found');
is($found[1]->first_name, 'Peter', 'second found');
