package Local::Chat::ClientConnection;

use 5.010;
use strict;
use Mouse;
BEGIN {if($]<5.018){package experimental; use warnings::register;}} no warnings 'experimental';

use JSON::XS;
use DDP;
use Data::Dumper;
use Scalar::Util qw(weaken);

extends 'Local::Chat::Connection';

our $JSON = JSON::XS->new->utf8;

has 'server', is => 'rw', required => 1;
has 'version', is => 'rw', default => sub {  shift->server->version };

has 'authorized', is => 'rw', default => 0, trigger => sub {

};

has 'pass', is => 'rw';

has 'rooms', is => 'ro', default => sub {{}};

has 'active', is => 'rw';
has 'fh', is => 'ro';

has 'remote', is => 'ro', default => sub {
	my $self = shift;
	return $self->fh->peerhost.':'.$self->fh->peerport;
};

has 'prev_nick', is => 'rw';
has 'nick', is => 'rw',
	trigger => sub {
		my $self = shift;
		# $self->prev_nick($_[1]); # Remember prev name
		$self->server->users->{ $self->nick } = $self;
		if (defined $self->prev_nick) {
			if ($self->prev_nick ne $self->nick) {
				delete $self->server->users->{ $self->prev_nick };
				$self->log("Rename from prev %s",$self->prev_nick);
				#$self->server->event("rename", { nick => $self->nick, prev => $self->prev_nick });
				for my $room (values %{ $self->rooms }) {
					$room->event("rename", { nick => $self->nick, prev => $self->prev_nick });
				}
			}
			else {
				$self->log("Prev eq nick");
			}
		}
	}
;

before 'nick' => sub {
	my $self = shift;
	if (@_) {
		$self->prev_nick($self->{nick}); # Remember prev name
	}
};

has 'on_disconnect', is => 'rw';
has 'on_packet', is => 'rw';
has 'on_message', is => 'rw';
has 'on_msg', is => 'rw';
has 'on_authorized', is => 'rw';

sub BUILD {
	my $self = shift;
	$self->connected(1);
	# ...
}

sub DEMOLISH {
	my $self = shift;
	warn "Destroying ".$self->ident;
}

sub ident {
	my $self = shift;
	return ( $self->nick // '~anon' ).'@'.$self->remote;
}


sub disconnect {
	my $self = shift;
	if (@_) {
		my $error = shift;
		$self->log("Disconnecting by error: @_");
		$self->write({ v => $self->version, event => "error", data => { text => "Closing connection by error: $error" } });
	} else {
		$self->wtite({ v => $self->version, event => "info", data => { text => "Closing connection"  } })
	}
	if ($self->on_disconnect) {
		$self->on_disconnect->($self);
	}
	close $self->fh;
}

sub on_eof {
	my $self = shift;
	$self->log( "Client disconnected" );
	if ($self->on_disconnect) {
		$self->on_disconnect->($self);
	}
	close $self->fh;
}

sub packet {
	# Function for processing incoming packet
	my $self = shift;
	my $pkt  = shift;

	if ( ref $pkt ne 'HASH' ) {
		return $self->disconnect("packet is not a hash");
	}
	unless ( $pkt->{v} and ( $pkt->{cmd} or $pkt->{event} ) and ref $pkt->{data} eq 'HASH' ) {
		return $self->disconnect("bad packet format ".$JSON->encode($pkt));
	}

	if ( $pkt->{v} > $self->version ) {
		return $self->write({ v => $self->version, event => "error", data => { text => "unsupported version $pkt->{v}" } });
	}

	my $data = $pkt->{data};

	given ($pkt->{cmd}) {
		when ("nick") {
			return $self->disconnect("data.nick required") unless $data->{nick};

			# Ask server, if we could use name
			return if $self->nick eq $data->{nick};


			if ($pkt->{v} == 1) {
				if( $self->server->validate_nick($self, $data->{nick}) ) {

					if (!$self->authorized) {
						$self->authorized(1);
						$self->on_authorized and $self->on_authorized->($self);
						return;
					}
				}
				else {
					# Rename
					# $self->server->user_rename($self);
				}
			}
			if ($pkt->{v} == 2) {
				return $self->disconnect("Password required") unless(exists $data->{pass} and defined $data->{pass});
				if ( $self->server->validate_nick($self, $data->{nick}) ) {
					if (!$self->authorized) {
						if ($self->server->validate_pass($self, $data->{pass})) {
							$self->authorized(1);
							$self->on_authorized and $self->on_authorized->($self);
							return;
						}
						else {
							return $self->disconnect("Wrong password");
						}
					}
				}
				else {
					$self->server->register_user($self, $data->{nick}, $data->{pass});
					return;
					# Rename
					# $self->server->user_rename($self);
				}
			}
		}
		when ("msg") {
			if (length $data->{text}) {
				# $self->server->message( $pkt->{data}{to}, $pkt->{data}{text} );
				$self->on_msg and 
					$self->on_msg->($self, $data);
				$self->on_message and 
					$self->on_message->($self, $pkt->{data}{text}, $pkt->{data}{to});
			}
			else {
				return $self->disconnect("data.text required");
			}
		}
		when ("names") {
			$self->server->names($self, $pkt->{data}{on})
		}
		when ("kill") {
			$self->server->kill($pkt->{data}{user})
		}
		default {
			return $self->disconnect("unknown command $pkt->{cmd}");
		}
	}

}

sub event {
	my $self = shift;
	my $e = shift;
	my $data = shift;
	$self->write({ v => $self->version, event => $e, data => $data });
}

sub hello {
	my $self = shift;
	$self->event("hello", { text => "Welcome to chat server!" });
}

sub message {
	my $self = shift;
	my $pkt = shift;
	$self->write({ v => $self->version, event => "msg", data => $pkt });
}

1;
