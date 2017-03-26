#!/usr/bin/env perl

use strict;
use warnings;
use FindBin; use lib "$FindBin::Bin/../lib";
use Test::More;

use_ok 'Local::Row::JSON';

is_deeply Local::Row::JSON->new( str => '{}' ), {}, "empty struct";
is_deeply Local::Row::JSON->new( str => '{"key":"val"}' ), {key => "val"}, "one pair";
is_deeply Local::Row::JSON->new( str => '{"a":1,"b":2}' ), { a => 1, b => 2 }, "two pairs";

is_deeply Local::Row::JSON->new( str => "test" ), undef, "not a json";
is_deeply Local::Row::JSON->new( str => '["json must be hash"]' ), undef, "not a hash json";
is_deeply Local::Row::JSON->new( str => '{"test":"val"' ), undef, "unbalanced json";

done_testing();
