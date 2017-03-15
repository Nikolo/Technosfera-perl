#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 9;

use myconst PI => 3.14, STRING => 'some string', STRING2 => 'some \' \" \\ string', STRING3 => 'some $VAR string';

my $val;

$val = eval { PI() };
is($val, 3.14, "PI is correct");
is(prototype("PI"), '', "PI prototype is empty");

$val = eval { STRING() };
is($val, 'some string', "STRING is correct");
is(prototype("STRING"), '', "STRING prototype is empty");

$val = eval { STRING2() };
is($val, 'some \' \" \\ string', "STRING2 is correct");
is(prototype("STRING2"), '', "STRING2 prototype is empty");

$val = eval { STRING3() };
is($val, 'some $VAR string', "STRING3 is correct");
is(prototype("STRING3"), '', "STRING3 prototype is empty");

$val = eval { math() };
ok($@, "Missing constant does not exist");
