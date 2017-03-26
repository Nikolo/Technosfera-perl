#!/usr/bin/env perl

use strict;
use warnings;
use FindBin; use lib "$FindBin::Bin/../lib";
use Test::More;

use_ok 'Local::Source::Array';

my @array = (1,2,'test');
my $src = Local::Source::Array->new(
    array => \@array,
);

ok $src, 'created source';
is $src->next, 1, "first";
is $src->next, 2, "second";
is $src->next, "test", "third";
is $src->next, undef, "other 1";
is $src->next, undef, "other 2";
is_deeply \@array, [1,2,"test"], "array kept intact";

done_testing();
