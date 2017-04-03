#!/usr/bin/env perl

use strict;
use warnings;
use FindBin; use lib "$FindBin::Bin/../lib";
use Test::More;

use_ok 'Local::Source::Text';

{
	my $copy = my $text = join "\n",qw(test1 test2 test3);
	my $src = Local::Source::Text->new(
		text => $text,
	);

	ok $src, 'created source';
	is $src->next, "test1", "first";
	is $src->next, "test2", "second";
	is $src->next, "test3", "third";
	is $src->next, undef, "other 1";
	is $src->next, undef, "other 2";
	is $text, $copy, "text kept intact";
}

{
	my $copy = my $text = join "!!",qw(test1 test2 test3);
	my $src = Local::Source::Text->new(
		text => $text,
		delimiter => "!!",
	);

	ok $src, 'created source';
	is $src->next, "test1", "first";
	is $src->next, "test2", "second";
	is $src->next, "test3", "third";
	is $src->next, undef, "other 1";
	is $src->next, undef, "other 2";
	is $text, $copy, "text kept intact";
}


done_testing();
