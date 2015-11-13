package Local::Hackathon::Client;

=for rem

# prefork server: 15 min

1. Queue                         #####
    + iproto + json
    + perfork
    + networking
    + storage
2. Queue storage                 #####
    + put(channel, task) -> id
    + take(channel) -> id, task
    + ack(id)
    + release(id)
    + requeue(id, channel, task) -> id
3. Urls generator
    + LJ atom feed               #####
    + RSS feed - ? (XML::RSS)    ####
4. Task processor (client) # HTML::Parser, Web::Query, Mojo::DOM, 
    + Client class, take, ( process, requeue ) | release
    requeuers:
    + URL -> content (fetcher)   ##
    + content -> title           #
    + 
    + content -> images          ##
    + content -> links           ##
    + content -> comments        ###
    + 
    + content -> words           ####
    + content -> opengraph       ####
    + content -> favicon         ####
    + content -> TOC             ####
    + content -> forms           ####
    
    single worker:
    + queue stats                ###

=cut

use strict;
use warnings;
use Local::Hackathon::Const;

use Socket;
use IO::Socket;
use Mouse;
use JSON::XS;
use Carp;

use DDP;

our $JSON = JSON::XS->new->utf8->pretty->allow_nonref;

has 'host', is => 'rw', default => 'localhost';
has 'port', is => 'rw', default => 3456;

has 'socket',  is => 'rw';
has 'seq',     is => 'rw', default => 0;

sub BUILD {
	my $self = shift;

	my $socket = IO::Socket::INET->new(
		Proto     => 'tcp',
		PeerAddr  => $self->host,
		PeerPort  => $self->port,
		Timeout   => 1,
	) or die "Can't connect to $self->{host}:$self->{port}: $!\n";

	$self->socket($socket);
}

sub request {
	my ($self, $pkt, $body) = @_;

	my $req_body = $JSON->encode($body);
	my $pkt_id   = ++$self->{seq};
	my $pkt_body = pack('VVV/a*', $pkt, $pkt_id, $req_body);

	my $wr = syswrite $self->socket, $pkt_body;
	if ($wr != length $pkt_body) {
		croak "Failed to write to server ($wr): $!";
	}

	my $rd = read($self->socket, my $buf, 12);
	# warn "read1: $rd";
	if ($rd != 12) {
		croak "Server reset connection ($rd/12): $!";
	}

	# p $buf;

	my ($pkt_re, $id, $len) = unpack 'VVV', $buf;

	if ($len > MAXBUF) {
		croak "Response to big or malformed data";
	}

	$rd = read($self->socket, $buf, $len);

	# warn "read2: $rd";

	if ($rd != $len) {
		croak "Server reset connection ($rd/$len): $!";
	}

	# p $buf;

	my $data;
	eval {
		$data = $JSON->decode( $buf );
	1} or do {
		croak "Failed to decode response JSON: $@";
	};

	if (ref $data) {
		return $data;
	}
	elsif (!defined $data) {
		return undef;
	}
	else {
		croak $data;
	}

	# p $data;
}


sub put {
	my $self = shift;
	my ($channel, $task) = @_;
	return $self->request(PKT_PUT, [ $channel, $task ]);
}

sub take {
	my $self = shift;
	my ($channel) = @_;
	return $self->request(PKT_TAKE, [ $channel ]);
}

sub ack {
	...
}

sub release {
	my $self = shift;
	my ($id) = @_;
	return $self->request(PKT_RELEASE, [ $id ]);
}

sub requeue {
	my $self = shift;
	my ($id, $newchannel, $task) = @_;
	return $self->request(PKT_REQUEUE, [ $id, $newchannel, $task ]);
}

1;

