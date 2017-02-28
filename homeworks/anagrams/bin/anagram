#!/usr/bin/env perl

use 5.010;  # for say, given/when
use strict;
use warnings;

BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';
our $VERSION = 1.0;

BEGIN{
	$|++;     # Enable autoflush on STDOUT
	$, = " "; # Separator for print x,y,z
	$" = " "; # Separator for print "@array";
}

use FindBin;
use IO::File;
use Data::Dumper;
use lib "$FindBin::Bin/../lib";
use Anagram;

open(my $fh, '<', "$FindBin::Bin/../dict.txt") or die $!;
my @list = map {
	my @v = split /\s+/, $_;
	@v == 1 ? $v[0] : \@v;
} grep { chomp; /\S/ } <$fh>;
close($fh);

my $result = Anagram::anagram(\@list);
say "$_: @{$result->{$_}}" foreach (sort keys %$result);

