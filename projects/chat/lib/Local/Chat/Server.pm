package Local::Chat::Server;

use 5.010;
use strict;
use Mouse;
BEGIN {if($]<5.018){package experimental; use warnings::register;}} no warnings 'experimental';


use Local::Chat::Room;
use Local::Chat::ClientConnection;

use AnyEvent::Util qw(fh_nonblocking);
use IO::Socket::INET;
use IO::Select;
use Socket;
use Data::Dumper;
use Time::HiRes qw(time);

has 'version', is => 'rw', default => 1;

has 'host', is => 'rw', required => 1, default => '0.0.0.0';
has 'port', is => 'rw', required => 1, default => 3456;
has 'fh', is => 'rw';
has 'sel', is => 'rw', default => sub { IO::Select->new() };

has 'delayed_events', is => 'rw', default => sub {[]};

has 'peers', is => 'ro', default => sub {{}};
has 'users', is => 'ro', default => sub {{}};

has 'send_message_to_sender', is => 'rw', default => 1;

has 'default_room', is => 'ro', default => sub {
	my $self = shift;
	Local::Chat::Room->new(
		name => '#all',
		server => $self,
	);
};

sub BUILD {
	my $self = shift;
	my $server = IO::Socket::INET->new(
		Listen    => 128,
		LocalAddr => $self->host,
		LocalPort => $self->port,
		ReuseAddr => 1,
		Proto     => 'tcp',
	) or die "$!";
	fh_nonblocking($server,1);
	$self->fh($server);
	$self->sel->add($server);
	printf "Server listening on %s:%s\n", $server->sockhost, $server->sockport;
}

sub log {
	my $self = shift;
	my $msg;
	if (@_ > 1 and index($_[0],'%') > -1) {
		$msg = sprintf $_[0],@_[1..$#_];
	} else {
		$msg = "@_";
	}
	printf STDERR "[Server] %s\n", $msg;
}

sub listen {
	my $self = shift;

	while () {
		if( my @handles = $self->sel->can_read( $self->min_wait ) ) {
			for my $fh (@handles) {
				if ($fh == $self->fh) {
					# It's main server handle

					my $peer = $fh->accept;
					$self->accept_client($peer);

				}
				else {
					# It's client handle

					my $remote = $fh->peerhost.':'.$fh->peerport;
					if ( my $client = $self->peers->{ $remote } ) {
						$client->read();
					}
					else {
						$self->log("No such client: $remote");
						$self->sel->remove( $fh );
					}

				}
			}
		}
		$self->process_delayed_events;
	}
}


sub min_wait {
	my $self = shift;
	@{ $self->delayed_events } ? time - $self->delayed_events->[0]{at} : 1;
}

sub delay_event {
	my $self = shift;
	my $wait = shift;
	my $cb = shift;
	push @{ $self->delayed_events }, { at => time + $wait, cb => $cb };
}

sub process_delayed_events {
	my $self = shift;
	my @events = sort { $a->{at} <=> $b->{at} } @{ $self->delayed_events };
	my $now = time;
	while (@events and $events[0]{at} <= $now) {
		my $ev = shift @events;
		$ev->{cb}->($self);
	}
	$self->delayed_events(\@events);
}

sub accept_client {
	my $self = shift;
	my $peer = shift;

	my $remote = $peer->peerhost.':'.$peer->peerport;
	say "Server accepted connection from $remote";
	fh_nonblocking($peer,1);

 	# temporary name
	my $nick = $self->randname(5,"anon")
		or return close $peer;

	my $client = Local::Chat::ClientConnection->new(
		fh     => $peer,
		server => $self,
		netlog => 1,
		nick   => $nick, 
		active => time(),
	);
	$self->sel->add( $peer );

	$self->peers->{ $remote } = $client; # register peer

	$client->on_authorized(sub {
		$self->log("User %s authorized",$client->nick);

		$self->default_room->join( $client );
	});

	$self->delay_event(1, sub {
		return if $client->authorized;
		$self->log("User %s not send us nickname. Autoreg", $client->nick);
		$client->event("nick", { nick => $client->nick });

		$self->default_room->join( $client );
	});


	$client->on_msg(sub {
		my ($client,$data) = @_;
		my $to = $data->{to};
		my $room = $to ? $self->rooms->{$to} : $self->default_room;
		if ($room->have($client)) {
			$room->message({
				from => $client->nick,
				text => $data->{text},
			});
		}
	});

	$client->on_disconnect(sub {
		my $client = shift;
		$self->log("removing client $peer");
		# Remove from connections
		delete $self->peers->{ $remote };

		# Remove from rooms
		for my $room ( $self->default_room ) {
			$room->remove( $client );
		}

		# Remove from nicknames
		delete $self->users->{ $client->nick };

		# Remove from IO::Select
		$self->sel->remove( $peer );
	});

	$client->hello();
}

sub randname {
	my $self = shift;
	my $min  = shift;
	my $nick = shift;
	for my $digits ($min..5) {
		my $max = 10**$digits;
		for (1..50) {
			my $guess = $nick . int(rand($max));
			if (!exists $self->users->{$guess}) {
				return $guess;
			}
		}
	}
	return;
}

sub validate_nick {
	my $self = shift;
	my ( $client,$nick ) = @_;

	my $current = $client->nick;

	# Try to autogenerate nick if it is already exists
	if (exists $self->users->{$nick}) {
		# Name is taken.
		# If user is authorized, then fallback to current

		if ($client->authorized) {
			$self->log("Nickname $nick is taken. Revert to $current");
			$client->event("nick", { nick => $client->nick });
			return;
		}

		if( my $new = $self->randname(1,$nick) ) {
			$self->log("Nickname $nick is taken. Offer $new");
			$nick = $new;			
		} else {
			# No current, no random. Sorry, closing.
			$client->disconnect("Failed to accept nickname");
			return;
		}
	}

	$client->nick($nick);

	# Notify client about it's nickname
	$client->event("nick", { nick => $client->nick });

	return 1;
}

sub all {
	my $self = shift;
	return values %{ $self->users };
}

sub event {
	my $self = shift;
	my $e = shift;
	my $data = shift;
	for my $client ($self->all) {
		$self->log("send event $e to ".$client->ident);
		$client->event($e,$data);
	}
}

sub names {
	my $self = shift;
	my $client = shift;
	my $room = shift // '#all';
	if ($room eq $self->default_room->name) {
		my $names = $self->default_room->names;
		$client->event(names => { room => $room, names => $names });
	}
	else {
		$client->event("error", { text => "No such room" });
	}
	# TODO
	# my $room = shift // '#main';
	# my $list = [ $rooms{$room}? ( map { $_->nick } values %{ $rooms{$room}{members} } ) : () ];
	# $requestor->event(names => { room => $room, names => $list });
}


sub kill {
	my $self = shift;
	my $user = shift;
	# TODO
}

1;
