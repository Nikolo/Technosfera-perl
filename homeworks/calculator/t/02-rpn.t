#!/usr/bin/env perl

use 5.010;
use strict;
use Test::More;
use FindBin;

my $tests = do "$FindBin::Bin/tests.pl" or die;
require "$FindBin::Bin/../lib/rpn.pl";

sub test_good_rpn($$) {
	my ($expression,$exp) = @_;
	my $got;
	eval {
		$got = rpn($expression);
	1} or do {
		fail "rpn( $expression )";
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
		fail "rpn( $expression )";
		diag "got: ",explain $got;
		diag "expected: ",explain $exp;
	} else {
		pass "t( $expression )";
	}
}

sub test_bad_rpn($) {
	my ($expression) = @_;
	my $got;
	eval {
		$got = rpn($expression);
	1} or do {
		pass "rpn( $expression )";
		# diag "Correctly died with $@";
		return;
	};
	fail "rpn( $expression )";
	diag "Must die, but return", explain $got;
}

plan tests => 3;

subtest 'Required', sub {
	plan tests => @{ $tests->{required}{good} }+@{ $tests->{required}{bad} };
	for (@{ $tests->{required}{good} }) {
		my ($in,$rpn,$val) = @$_;
		test_good_rpn($in,[split /\s+/, $rpn])
	}
	for (@{ $tests->{required}{bad} }) {
		my ($in,$rpn,$val) = @$_;
		test_bad_rpn($in);
	}
};

subtest 'No space in expression', sub {
	plan tests => @{ $tests->{nospace}{good} }+@{ $tests->{nospace}{bad} };
	for (@{ $tests->{nospace}{good} }) {
		my ($in,$rpn,$val) = @$_;
		test_good_rpn($in,[split /\s+/, $rpn])
	}
	for (@{ $tests->{nospace}{bad} }) {
		my ($in,$rpn,$val) = @$_;
		test_bad_rpn($in);
	}
};

subtest 'Unary ops', sub {
	plan tests => @{ $tests->{unary}{good} }+@{ $tests->{unary}{bad} };
	for (@{ $tests->{unary}{good} }) {
		my ($in,$rpn,$val) = @$_;
		test_good_rpn($in,[split /\s+/, $rpn])
	}
	for (@{ $tests->{unary}{bad} }) {
		my ($in,$rpn,$val) = @$_;
		test_bad_rpn($in);
	}
};
