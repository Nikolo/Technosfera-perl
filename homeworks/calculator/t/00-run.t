#!/usr/bin/env perl

use 5.010;
use strict;
use FindBin;
use Test::More tests => 6;
use FindBin;

my $calc = "$FindBin::Bin/../bin/calculator";
my $tests = do "$FindBin::Bin/tests.pl" or die;

for(
	[ 'required', 'good' ],
	[ 'required', 'bad'  ],
	[ 'nospace',  'good' ],
	[ 'nospace',  'bad'  ],
	[ 'unary',    'good' ],
	[ 'unary',    'bad'  ],
) {
	my ($k1,$k2) = @$_;
	my $testdata = "$FindBin::Bin/test.$k1.$k2.data";
	open my $f, '>:raw', $testdata or die "Failed to open $!";
	for ( @{ $tests->{$k1}{$k2} }) {
		my ($in,$rpn,$val) = @$_;
		print {$f} $in, "\n";
	}
	close $f;
	my @out = qx("$^X" "$calc" "$testdata" 2>&1);
	subtest "\u$k1 $k2", sub {
		plan tests => 1+2*@{ $tests->{$k1}{$k2} };
		my $exitcode = $? >> 8;
		is $exitcode, 0, "extcode $k1 $k2";
		for ( @{ $tests->{$k1}{$k2} }) {
			my ($in,$rpn,$val) = @$_;
			my ($res_rpn,$res_val) = splice @out, 0, 2;
			s{\015?\012$}{}s for ($res_rpn,$res_val);
			if ( $k2 ne 'bad' ) {
				is $res_rpn, $rpn, "rpn $in";
				is $res_val, $val, "val $in";
			} else {
				like $res_rpn, $rpn, "rpn $in";
				is $res_val, $val, "val $in";
			}
		}
	};
}
