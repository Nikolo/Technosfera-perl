#!/usr/bin/env perl

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

use FindBin;
use lib "$FindBin::Bin/../lib";
use Anagram;
use Test::More;
use Data::Dumper;

use constant RESULT => "{'пятка' => ['пятак','пятка','тяпка'],'слиток' => ['листок','слиток','столик']}";

plan tests => 1;

my $result = Anagram::anagram([qw(пятка слиток пятак ЛиСток стул ПяТаК тяпка столик слиток)]);
my $dump = Data::Dumper->new([$result])->Purity(1)->Terse(1)->Indent(0)->Sortkeys(1);

is($dump->Dump, RESULT, "example");


1;
