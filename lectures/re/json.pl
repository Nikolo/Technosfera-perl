#!/usr/bin/env perl

use strict;
use DDP;
use JSON::XS 'decode_json';

my $data = do { # чтение файла
	open my $f,'<:raw',$ARGV[0]
	or die "open `$ARGV[0]' failed: $!";
	local $/; <$f>
};

my $struct = decode_json($data);
p $struct;
