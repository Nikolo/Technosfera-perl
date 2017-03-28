#!/usr/bin/env perl

use 5.010;
use strict;

use Socket ':all';

socket my $s, AF_INET, SOCK_STREAM, IPPROTO_TCP or die "socket: $!";

# setsockopt $s, SOL_SOCKET, SO_REUSEADDR, 1 or die "sso: $!";
# setsockopt $s, SOL_SOCKET, SO_REUSEPORT, 1 or die "sso: $!";

bind $s, sockaddr_in(1234, INADDR_ANY) or die "bind: $!";

listen $s, SOMAXCONN or die "listen: $!";

my ($port, $addr) = sockaddr_in(getsockname($s));
say "Listening on ".inet_ntoa($addr).":".$port;

while (my $peer = accept my $c, $s) {
    # got client socket $c

    my ($port, $addr) = sockaddr_in($peer);
    my $ip = inet_ntoa($addr);
    my $host = gethostbyaddr($addr, AF_INET);
    say "Client connected from $ip:$port ($host)";

    # use IO::Handle;
    # $c->autoflush(1);

    while (<$c>) { # read from client
    	say "got line '$_'";
    	# syswrite $c, $_;
        print {$c} $_ or warn; # send it back
    }
}
