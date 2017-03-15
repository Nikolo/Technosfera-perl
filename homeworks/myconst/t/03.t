#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 7;

use myconst math => {PI => 3.14, E => 2.7 }, STRING => 'some string';

my $val;

$val = eval { PI() };
is($val, 3.14, "PI is correct");
is(prototype("PI"), '', "PI prototype is empty");

$val = eval { E() };
is($val, 2.7, "E is correct");
is(prototype("E"), '', "E prototype is empty");

$val = eval { STRING() };
is($val, 'some string', "STRING is correct");
is(prototype("STRING"), '', "STRING prototype is empty");

$val = eval { math() };
ok($@, "Missing constant does not exist");
