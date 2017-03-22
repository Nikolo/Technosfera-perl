#!/usr/bin/env perl

use 5.010;
use strict;
use AE;

sub async {
    my $cb = pop;
    my $w;$w = AE::timer rand(0.1),0,sub {
        undef $w;
        $cb->();
    };
    return;
}

say "title parallel";

my $cv = AE::cv;
my @array = 1..10;

# say "participant run";
# for (@array) {
# 	say "participant $_";
# }
# say "participant end";

my $last;
for my $cur (@array) {
    say "Process $cur";
    $cv->begin;
    async sub {
        say "Processed $cur ";
        # say "run -> $cur:";
        $last = $cur;
        $cv->end;
    };
}
$cv->recv;
# say "$last -> end:";

say '-------';

my $cv = AE::cv; $cv->begin;
my @array = 1..10;
my $i = 0;
my $next; $next = sub {
    my $cur = $i++;
    return if $cur > $#array;
    say "Process $array[$cur]";
    $cv->begin;
    async sub {
        say "Processed $array[$cur]";
        $next->();
        $cv->end;
    };
}; $next->() for 1..3;
$cv->end; $cv->recv;