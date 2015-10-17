package Sfera::TCP::Calc::Client;

use strict;
use IO::Socket;
use Sfera::TCP::Calc;

sub set_connect {
	my $pkg = shift;
	my $ip = shift;
	my $port = shift;
	...
}

sub do_request {
	my $pkg = shift;
	my $server = shift;
	my $type = shift;
	#Sfera::TCP::Calc->pack_message
	#Sfera::TCP::Calc->pack_header
	#send to server
	#receive answer
	#Sfera::TCP::Calc->unpack_header
	#Sfera::TCP::Calc->unpack_message(
}

1;

