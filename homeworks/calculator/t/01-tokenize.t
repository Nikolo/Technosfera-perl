#!/usr/bin/env perl

use 5.010;
use strict;
use Test::More;
use Test::Deep;
use FindBin;

sub tokenize($);
require "$FindBin::Bin/../lib/tokenize.pl";

sub test_good_tokenize($$) {
	my ($expression,$exp) = @_;
	my $got;
	eval {
		$got = tokenize($expression);
	1} or do {
		fail "t( $expression )";
		diag "Died with $@";
		return;
	};
	my $ok = 0;
	CHECK: {
		last if ref $got ne ref $exp;
		last if $#$got != $#$exp;
		for (0..$#$got) {
			last CHECK if $got->[$_] ne $exp->[$_];
		}
		$ok = 1;
	}
	if (not $ok) {
		fail "t( $expression )";
		diag "got: ",explain $got;
		diag "expected: ",explain $exp;
	} else {
		pass "t( $expression )";
	}
}

sub test_bad_tokenize($) {
	my ($expression) = @_;
	my $got;
	eval {
		$got = tokenize($expression);
	1} or do {
		pass "t( $expression )";
		# diag "Correctly died with $@";
		return;
	};
	fail "t( $expression )";
	diag "Must die, but return", explain $got;
}

local $TODO = 'recommended to implement';

test_good_tokenize '0', ['0'];
test_good_tokenize '0e0', ['0'];
test_good_tokenize '0e+0', ['0'];
test_good_tokenize '0e-0', ['0'];
test_good_tokenize '0e+1', ['0'];
test_good_tokenize '0e-1', ['0'];
test_good_tokenize '-0', ['U-','0'];
test_good_tokenize '+0', ['U+','0'];

test_good_tokenize '-1', ['U-','1'];
test_good_tokenize '-1--2', ['U-','1','-','U-','2'];

test_good_tokenize '1+1', ['1','+','1'];
test_good_tokenize '1-1', ['1','-','1'];
test_good_tokenize '1*1', ['1','*','1'];
test_good_tokenize '1/1', ['1','/','1'];
test_good_tokenize '1^1', ['1','^','1'];

test_good_tokenize '1+(1-1)', ['1','+','(','1','-','1',')'];
test_good_tokenize '1.5*(13.3-8)/9.0^.5+1e+3-2', [qw(1.5 * ( 13.3 - 8 ) / 9 ^ 0.5 + 1000 - 2)];

test_bad_tokenize '(1-)';
test_bad_tokenize '1 1';
test_bad_tokenize '1 * /';
test_bad_tokenize '1 - - /';
test_bad_tokenize '+';
test_bad_tokenize '1 +';

done_testing();
