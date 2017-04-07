#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 34;

my $val;


#####################################################
package nnn;
use myconst phys => {g => 9.81 , PI => 3.1416 };
BEGIN { $INC{"nnn.pm"} = "1"; } # fuck you you fucking fuck
#####################################################
#####################################################
package aaa;
use myconst math => {PI => 3.14, E => 2.7 }, STRING => 'some string';
BEGIN { $INC{"aaa.pm"} = "1"; } # fuck you you fucking fuck
#####################################################

#####################################################
package bbb1;
use aaa qw/PI STRING/;

package bbb2;
use aaa qw/:math STRING/;

package bbb3;
use aaa qw/:all/;

package bbb4;
use aaa qw/STRING :all :math/;

package mmm3;
use nnn qw/:phys/;
#####################################################

package main;

#####################################################
$val = eval { aaa::PI() };
is($val, 3.14, "PI is correct");

$val = eval { aaa::E() };
is($val, 2.7, "E is correct");

$val = eval { aaa::STRING() };
is($val, 'some string', "STRING is correct");

$val = eval { aaa::math() };
ok($@, "Missing constant does not exist");
#####################################################

#####################################################
$val = eval { nnn::g() };
is($val, 9.81, "g is correct");

$val = eval { nnn::PI() };
is($val, 3.1416, "PI is correct");

$val = eval { nnn::phys() };
ok($@, "Missing constant does not exist");
#####################################################

#####################################################
$val = eval { bbb1::PI() };
is($val, 3.14, "PI is correct");

$val = eval { bbb1::E() };
ok($@, "Missing constant does not exist");

$val = eval { bbb1::STRING() };
is($val, 'some string', "STRING is correct");

$val = eval { bbb1::math() };
ok($@, "Missing constant does not exist");
#####################################################

#####################################################
$val = eval { bbb2::PI() };
is($val, 3.14, "PI is correct");
is(prototype("bbb2::PI"), '', "PI prototype is empty");

$val = eval { bbb2::E() };
is($val, 2.7, "E is correct");
is(prototype("bbb2::E"), '', "E prototype is empty");

$val = eval { bbb2::STRING() };
is($val, 'some string', "STRING is correct");
is(prototype("bbb2::STRING"), '', "STRING prototype is empty");

$val = eval { bbb2::math() };
ok($@, "Missing constant does not exist");
#####################################################

#####################################################
$val = eval { bbb3::PI() };
is($val, 3.14, "PI is correct");
is(prototype("bbb3::PI"), '', "PI prototype is empty");

$val = eval { bbb3::E() };
is($val, 2.7, "E is correct");
is(prototype("bbb3::E"), '', "E prototype is empty");

$val = eval { bbb3::STRING() };
is($val, 'some string', "STRING is correct");
is(prototype("bbb3::STRING"), '', "STRING prototype is empty");

$val = eval { bbb3::math() };
ok($@, "Missing constant does not exist");
#####################################################

#####################################################
$val = eval { mmm3::g() };
is($val, 9.81, "g is correct");
is(prototype("mmm3::g"), '', "g prototype is empty");

$val = eval { mmm3::PI() };
is($val, 3.1416, "PI is correct");
is(prototype("mmm3::PI"), '', "c prototype is empty");

$val = eval { mmm3::phys() };
ok($@, "Missing constant does not exist");
#####################################################

#####################################################
$val = eval { bbb4::PI() };
is($val, 3.14, "PI is correct");

$val = eval { bbb4::E() };
is($val, 2.7, "E is correct");

$val = eval { bbb4::STRING() };
is($val, 'some string', "STRING is correct");

$val = eval { bbb4::math() };
ok($@, "Missing constant does not exist");
#####################################################
