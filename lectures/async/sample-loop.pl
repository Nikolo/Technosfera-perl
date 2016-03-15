#!/usr/bin/env perl
use AE;
use 5.010;
use strict;

sub async {
    my $cb = pop;
    my $w;$w = AE::timer rand(0.1),0,sub {
        undef $w;
        $cb->();
    };
    return;
}

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
}; $next->() for 1..5;
$cv->end; $cv->recv;

# my @array = 1..10;

# my $i = 0;
# my $next; $next = sub {
#     my $cur = $i++;
#     return if $cur > $#array;
#     say "Process $array[$cur]";
#     async sub {
#         say "Processed $array[$cur]";
#         $next->();
#     };
# }; $next->();# for 1..5;

# AE::cv->recv;