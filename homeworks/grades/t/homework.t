use strict;
use warnings;

use Test::More tests => 2;
use Test::DBIx::Class;

my $rs = Schema->resultset('Homework');

$rs->create({name => 'test1', path => '/hw/test1'});
$rs->create({name => 'test2', path => '/hw/test2'});
$rs->create({name => 'test3'});

my @no_path = $rs->search_no_path()->all();

is(scalar @no_path, 1, 'no_path size');
is($no_path[0]->name, 'test3', 'no_path content');
