#!/usr/bin/perl

use strict qw/vars subs/;
use warnings;
use Test::More tests => 12;

sub xx1  { "xx1"   }

no myprivate;

sub _xx2 { "_xx2"  }

use myprivate;

sub xx3  { "xx3"  }

use myprivate;

sub _xx4 { "_xx4" }

no myprivate;

sub xx5  { "xx5"  }
sub _xx6 { "_xx6" }


foreach my $sub (qw/xx1 _xx2 xx3 _xx4 xx5 _xx6/) {
    my $res = eval { &{ "main::$sub" }; };
    is($res, $sub, "sub $sub returned correct value inside main");
}


package other::pkg;

use Test::More;

foreach my $sub (qw/xx1 _xx2 xx3 xx5 _xx6/) {
    my $res = eval { &{ "main::$sub" }; };
    is($res, $sub, "sub $sub returned correct value outside main");
}

foreach my $sub (qw/_xx4/) {
    my $res = eval { &{ "main::$sub" }; };
    ok(!defined $res && $@ =~ /^Private sub/, "sub $sub can't be called outside main");
}


