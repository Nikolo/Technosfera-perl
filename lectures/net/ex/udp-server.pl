#!/usr/bin/env perl

use 5.010;
use strict;

use Socket ':all';

socket my $s, AF_INET, SOCK_DGRAM, IPPROTO_UDP or die "socket: $!";

setsockopt $s, SOL_SOCKET, SO_REUSEADDR, 1 or die "sso: $!";

bind $s, sockaddr_in(1234, INADDR_ANY) or die "bind: $!";

# listen $s, SOMAXCONN or die "listen: $!";

my ($port, $addr) = sockaddr_in(getsockname($s));
say "Listening on ".inet_ntoa($addr).":".$port;

while (my $peer = recv( $s, my $msg, 2048, 0 )) {
    my ($port, $addr) = sockaddr_in($peer);
    my $ip = inet_ntoa($addr);
    say "Message $msg from $ip:$port";
}
