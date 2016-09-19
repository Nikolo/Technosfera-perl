#!/usr/bin/perl

use strict qw/vars subs/;
use warnings;
use Test::More tests => 32;

sub xx1  { "xx1"   }
sub _xx2 { "_xx2"  }

$main::xx1 = "xx1";
$main::_xx2 = "_xx2";

{
    package main::sometrash;

    sub xx1  { "sometrash::xx1"  }
    sub _xx2 { "sometrash::_xx2" }
}

use myprivate;

sub xx3  { "xx3"  }
sub _xx4 { "_xx4" }
$main::xx3 = "xx3";
$main::_xx4 = "_xx4";

{
    no warnings 'once';
    $main::xx7 = "xx7";
    $main::_xx8 = "_xx8";
}

no myprivate;

sub xx5  { "xx5"  }
sub _xx6 { "_xx6" }
$main::xx5 = "xx5";
$main::_xx6 = "_xx6";


foreach my $sub (qw/xx1 _xx2 xx3 _xx4 xx5 _xx6 sometrash::xx1 sometrash::_xx2/) {
    my $res = eval { &{ "main::$sub" }; };
    is($res, $sub, "sub $sub returned correct value inside main");
}

foreach my $sub (qw/xx1 _xx2 xx3 _xx4 xx5 _xx6 xx7 _xx8/) {
    is(${"main::$sub"}, $sub, "var $sub contains correct value");
}


package other::pkg;

use Test::More;

foreach my $sub (qw/xx1 _xx2 xx3 xx5 _xx6 sometrash::xx1 sometrash::_xx2/) {
    my $res = eval { &{ "main::$sub" }; };
    is($res, $sub, "sub $sub returned correct value outside main");
}

foreach my $sub (qw/_xx4/) {
    my $res = eval { &{ "main::$sub" }; };
    ok(!defined $res && $@ =~ /^Private sub/, "sub $sub can't be called outside main");
}

foreach my $sub (qw/xx1 _xx2 xx3 _xx4 xx5 _xx6 xx7 _xx8/) {
    is(${"main::$sub"}, $sub, "var $sub contains correct value");
}

