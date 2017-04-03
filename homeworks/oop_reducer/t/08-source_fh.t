#!/usr/bin/env perl

use strict;
use warnings;
use FindBin; use lib "$FindBin::Bin/../lib";
use Test::More;

do {
    local $TODO = "optional";
    use_ok 'Local::Source::FileHandle';
} or do {
    diag "Source::FileHandle is not implemented but recommended";
    done_testing();
    exit;
};

local $TODO = "FileHandle is optional";

{
	my $src = Local::Source::FileHandle->new(
		fh => \*DATA,
	);

	ok $src, 'created source';
	is $src->next, "test1", "first";
	is $src->next, "test2", "second";
	is $src->next, "test3", "third";
	is $src->next, undef, "other 1";
	is $src->next, undef, "other 2";
}

done_testing();

__DATA__
test1
test2
test3
