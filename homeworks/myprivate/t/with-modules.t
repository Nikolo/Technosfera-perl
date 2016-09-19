#!/usr/bin/perl

use strict qw/vars subs/;
use warnings;
use lib "t/";
use Test::More tests => 24;

sub xx1  { "xx1"   }
sub _xx2 { "_xx2"  }

use myprivate;

sub xx3  { "xx3"  }
sub _xx4 { "_xx4" }

use MyPrivateTest;

no myprivate;

sub xx5  { "xx5"  }
sub _xx6 { "_xx6" }


foreach my $sub (qw/xx1 _xx2 xx3 _xx4 xx5 _xx6/) {
    my $res = eval { &{ "main::$sub" }; };
    is($res, $sub, "sub $sub returned correct value inside main");
}

package MyPrivateTest;

use Test::More;

foreach my $sub (qw/xx1 _xx2 xx3 _xx4 xx5 _xx6/) {
    my $res = eval { &{ "MyPrivateTest::$sub" }; };
    is($res, "MyPrivateTest::$sub", "sub $sub returned correct value inside main");
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

foreach my $sub (qw/xx1 _xx2 xx3 xx5 _xx6/) {
    my $res = eval { &{ "MyPrivateTest::$sub" }; };
    is($res, "MyPrivateTest::$sub", "sub $sub returned correct value inside main");
}

foreach my $sub (qw/_xx4/) {
    my $res = eval { &{ "MyPrivateTest::$sub" }; };
    ok(!defined $res && $@ =~ /^Private sub/, "sub $sub can't be called outside main");
}
