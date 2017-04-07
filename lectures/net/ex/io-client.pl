#!/usr/bin/env perl

use 5.010;
use strict;

use IO::Socket;
my $socket = IO::Socket::INET->new(
    PeerAddr => 'search.cpan.org',
    PeerPort => 80,
    Proto    => "tcp",
    Type     => SOCK_STREAM,
) or die "Can't connect to search.cpan.org: $!";

print $socket 
   "GET / HTTP/1.0\nHost: search.cpan.org\n\n";

my @answer = <$socket>;
print @answer[0..9];
