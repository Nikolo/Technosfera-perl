#!/usr/bin/perl

use strict qw/vars subs/;
use warnings;
use Test::More tests => 4;

sub xx1  { "xx1"  }
sub _xx2  { "_xx2"  }

no myprivate;

sub xx3 { "xx3" }
sub _xx4 { "_xx4" }


foreach my $sub (qw/xx1 _xx2 xx3 _xx4/) {
    my $res = eval { &$sub; };
    is($res, $sub, "sub $sub returned correct value inside main");
}

