#!/usr/bin/env perl

use 5.010;
use strict;

my $vec;
vec($vec,4,1) = 1;
vec($vec,7,1) = 1;

say unpack "B*", $vec;

say log(8*length $vec)/log 2;

say join " ", grep vec($vec,$_,1), 0..8*length($vec)-1;

sub ready_fds { my $vec = shift;
	map { fileno_to_fd($_) }
	grep { vec($vec,$_,1) }
		0..8*length($vec)-1;
}