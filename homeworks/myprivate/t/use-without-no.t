#!/usr/bin/perl

use strict qw/vars subs/;
use warnings;
use Test::More tests => 8;

sub xx1  { "xx1"  }
sub _xx2  { "_xx2"  }

use myprivate;

sub xx3 { "xx3" }
sub _xx4 { "_xx4" }


foreach my $sub (qw/xx1 _xx2 xx3 _xx4/) {
    my $res = eval { &{ "main::$sub" }; };
    is($res, $sub, "sub $sub returned correct value inside main");
}


package other::pkg;

use Test::More;

foreach my $sub (qw/xx1 _xx2 xx3/) {
    my $res = eval { &{ "main::$sub" }; };
    is($res, $sub, "sub $sub returned correct value outside main");
}

foreach my $sub (qw/_xx4/) {
    my $res = eval { &{ "main::$sub" }; };
    ok(!defined $res && $@ =~ /^Private sub/, "sub $sub can't be called outside main");
}


