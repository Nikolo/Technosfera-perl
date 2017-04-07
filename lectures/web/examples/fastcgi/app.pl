#!/usr/bin/env perl

use warnings;
use strict;

use FCGI; 

my $socket = FCGI::OpenSocket(":9000", 5);

my $request = FCGI::Request(
    \*STDIN, \*STDOUT, \*STDERR, \%ENV, $socket
);

my $count = 1;

while($request->Accept() >= 0) {
    print "Content-Type: text/html\r\n\r\n";
    print $count++;
}

