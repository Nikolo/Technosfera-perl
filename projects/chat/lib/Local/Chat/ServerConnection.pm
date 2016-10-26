package Local::Chat::ServerConnection;

use 5.010;
use strict;
use Mouse;
BEGIN {if($]<5.018){package experimental; use warnings::register;}} no warnings 'experimental';

use JSON::XS;
use AnyEvent::Util qw(fh_nonblocking);
use IO::Socket::INET;
use IO::Select;
use Socket;
use DDP;
use Data::Dumper;

our $JSON = JSON::XS->new->utf8;

extends 'Local::Chat::Connection';

has 'version', is => 'rw', default => 1;
has 'host', is => 'rw', required => 1;
has 'port', is => 'rw', required => 1, default => 3456;
has 'sel', is => 'rw', default => sub { IO::Select->new() };

has 'connected',  is => 'rw';

has 'on_disconnect', is => 'rw';
has 'on_fd',      is => 'rw';
has 'on_hello',   is => 'rw';
has 'on_idle',    is => 'rw';
has 'on_message', is => 'rw';
has 'on_msg',     is => 'rw';
has 'on_error',   is => 'rw';
has 'on_names',   is => 'rw';
has 'on_join',    is => 'rw';
has 'on_part',    is => 'rw';
has 'on_rename',  is => 'rw';

has 'nick',       is => 'rw', trigger => sub {
	my $self = shift;
	if ($self->connected) {
		$self->command( 'nick', { nick => $self->nick } );
	}
};

sub ident {
	my $self = shift;
	return $self->nick.'@'.$self->remote;
}

sub connect {
	my $self = shift;
	return 1 if $self->connected;
	my $fh = IO::Socket::INET->new(
		PeerAddr => $self->host,
		PeerPort => $self->port,
		Proto    => 'tcp',
	) or die "Failed to connect to @{[ $self->host ]}:@{[ $self->port ]} $!\n";
	$self->connected(1);
	$self->fh( $fh );

	$self->sel->add($fh);
	return 1;
}

sub BUILD {
	my $self = shift;
	$self->connect();
}


sub disconnect {
	my $self = shift;
	$self->connected(0);
	if (@_) {
		my $error = shift;
		warn "$error";
	}
	close $self->fh;
	$self->on_disconnect and
		$self->on_disconnect->($self);
}

sub on_eof {
	my $self = shift;
	#warn "Server connection closed";
	$self->connected(0);	
	$self->on_disconnect and
		$self->on_disconnect->($self);
}

sub poll {
	my $self = shift;

	while ($self->connected) {
		if( my @handles = $self->sel->can_read(1) ) {
			for my $fd (@handles) {
				if ($fd == $self->fh) {
					#warn "self conn";
					$self->read;
					# self connection
				}
				elsif ($self->on_fd) {
					$self->on_fd->( $self, $fd );
				}
				else {
					warn "Unknown readable fd: $fd";
					close($fd);
					$self->sel->remove($fd);
				}
			}
		}
		else {
			# warn "Nothing to read";
		}
		$self->on_idle and $self->on_idle->($self);
	}
}

sub packet {
	my $self = shift;
	my $pkt  = shift;
	if ( ref $pkt ne 'HASH' ) {
		return $self->disconnect("packet is not a hash");
	}
	unless ( $pkt->{v} and ( $pkt->{cmd} or $pkt->{event} ) and ref $pkt->{data} eq 'HASH' ) {
		return $self->disconnect("bad packet format ".$JSON->encode($pkt));
	}

	my $data = $pkt->{data};

	if ($pkt->{cmd}) {
		given ($pkt->{cmd}) {
			default {
				return $self->disconnect("bad cmd packet ".$JSON->encode($pkt));
			}
		}
	}
	elsif ( $pkt->{event} and not ref $pkt->{event} ) {
		given ($pkt->{event}) {
			when ("hello") {
				if (length $self->nick) {
					$self->command( 'nick', { nick => $self->nick } );
				}
			}
			when ("nick") {
				# don't use accessor to not trigger event
				if ($self->{nick} ne $pkt->{data}{nick}) {
					$self->log("Server says our nickname should be $pkt->{data}{nick}");
					$self->{nick} = $pkt->{data}{nick};
				}
			}
			when( [qw(error names join part rename)]) {
				my $callback = 'on_'.$pkt->{event};
				if ($self->can($callback)) {
					$self->$callback and
						$self->$callback->($self, $data);
				} else {
					warn "No callback for $callback";
				}
			}
			when ("msg") {
				$self->on_msg and 
					$self->on_msg->($self, $data);
				$self->on_message and 
					$self->on_message->($self, $pkt->{data});
			}
			default {
				return $self->disconnect("bad event packet ".$JSON->encode($pkt));
			}
		}
	}
	else {
		return $self->disconnect("bad packet ".$JSON->encode($pkt));
	}

}

sub message {
	my $self = shift;
	my $pkt = shift; # { text => "message text", to => 'nick|#room' } | $msg
	$pkt = { text => $pkt } unless ref $pkt;
	$self->command( 'msg', $pkt );
}

sub names {
	my $self = shift;
	my $on = shift // '#all';
	$self->command( 'names' => { on => $on } );
}

sub kill {
	my $self = shift;
	my $user = shift;
	$self->command( 'kill' => { user => $user } );
}


1;

