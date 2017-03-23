#!/usr/bin/env perl

use 5.010;
use strict;

use Socket ':all';

socket my $s, AF_INET, SOCK_DGRAM, IPPROTO_UDP or die "socket: $!";

my $host = 'localhost'; my $port = 1234;
my $addr = gethostbyname $host;
my $sa = sockaddr_in($port, $addr);

send($s, "test direct message", 0, $sa);

connect $s, $sa;
send($s, "test 'connected' message", 0);
