#!/usr/bin/env perl
use AE;
use 5.010;

my $w;$w = AE::timer 1,1, sub {
	$w;
	printf "now: %f, timer...\n",AE::now();
	my $i;$i = AE::idle sub { undef $i;
		printf "now: %f, idle...\n",AE::now();
	};
};
# my $i = AE::idle sub {
# 	printf "now: %f, idle...\n",AE::now();
# };

AE::cv->recv;
