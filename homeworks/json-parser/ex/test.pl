#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Local::JSONParser;
use DDP;

@ARGV or die "Usage:\n\tperl $0 file\n";
my $file = shift @ARGV;

open my $f, '<:raw', $file or die "Can't open file `$file': $!\n";
my $source = do { local $/; <$f> };
close $f;

my $data = parse_json( $source );
p $data;
