#!/usr/bin/env perl

use strict;
use XML::Atom::Stream ();
use DDP;
use Data::Dumper;
use POSIX 'strftime';

my $client = XML::Atom::Stream->new(
	callback  => \&callback,
	reconnect => 1,
	# debug     => 1,
	timeout   => 30,
);
$client->connect('http://atom.services.livejournal.com/atom-stream.xml');

sub callback {
	my ($atom) = @_;
	eval {
		for my $ent ($atom->entries) {
			printf "%s %s # %s\n",strftime("%Y-%m-%dT%H:%M:%S",localtime()), $ent->link->href, $ent->title;
		}
	1} or do {
		warn "$@";
	};
}

