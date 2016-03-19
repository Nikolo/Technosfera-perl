#!/usr/bin/perl

use strict;
use Local::App::GenCalc;
use IO::Socket;
use Time::HiRes qw/alarm/;

$SIG{__ALRM__} = sub {
    Local::App::GenCalc::new_one();
};

my $port = 9899;
my $server = IO::Socket::INET->new(
    LocalPort => $port,
    Type      => SOCK_STREAM,
    ReuseAddr => 1,
    Listen    => 10) 
or die "Can't create server on port $port : $@ $/";

alarm(100);
while(my $client = $server->accept()){
    alarm(0);
    my $msg_len;
    if (sysread($client, $msg_len, 2) == 2){
        my $limit = unpack 'S', $msg_len;
        my $ex = Local::App::GenCalc::get($limit);
        syswrite($client, pack('L', scalar($ex)), 4);
        while (@$ex) {
            syswrite($client, pack('w/a*', $_));
        }
    }
    close( $client );
    alarm(100);
}
close( $server );

