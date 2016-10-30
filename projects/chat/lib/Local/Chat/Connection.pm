package Local::Chat::Connection;

use 5.010;
use strict;
use Mouse;
BEGIN {if($]<5.018){package experimental; use warnings::register;}} no warnings 'experimental';

use JSON::XS;
use AnyEvent::Util qw(fh_nonblocking);
use DDP;
use Data::Dumper;
use Time::HiRes qw(sleep time);

use constant MAXBUF => 1024*1024;

our $JSON = JSON::XS->new->utf8;

has 'fh', is => 'rw', trigger => sub {
	my $self = shift;
	if ($self->fh) {
		fh_nonblocking($self->fh,1);
		$self->remote( $self->fh->peerhost.':'.$self->fh->peerport );
	}
};

has 'remote', is => 'rw', default => '';

has 'connected',  is => 'rw';
has 'rbuf', is => 'rw', default => '';

has 'netlog', is => 'rw', default => 0;

sub BUILD {
	my $self = shift;
}

sub disconnect {
#	...
}

sub on_eof {
#	...
}

sub ident {
	''
}

sub log {
	my $self = shift;
	return unless $self->netlog;
	my $msg;
	if (@_ > 1 and index($_[0],'%') > -1) {
		$msg = sprintf $_[0],@_[1..$#_];
	} else {
		$msg = "@_";
	}
	# printf STDERR "\n", $self->ident, $msg;
	printf STDERR "%s-- %s %s%s\n", (-t STDERR ? "\e[1;35m" : "" ), $self->ident, $msg, (-t STDERR ? "\e[0m" : "" );
}

sub read : method {
	my $self = shift;
#	warn "call read ".$self->fh;
	my $buf = $self->rbuf;
	my $res = sysread $self->fh, $buf, MAXBUF-length($buf), length($buf);
	if ($res) {
		# read some from client
	}
	elsif (defined $res) {
		$self->log( "Connection closed" );
		$self->connected(0);
	}
	elsif ($! == Errno::EAGAIN) {
		# no more data
	}
	else {
		$self->log( "Connection error: $!" );
		$self->connected(0);
	}

	# TODO: here mey be a bug

	my @lines;
	while ($buf =~ m{\G([^\n]*)\n}gc) {
		push @lines, $1;
	}
	# p $buf;
	# p @lines;
	if ($self->netlog) {
		for (@lines) {
			printf STDERR "%s<< %s %s%s\n", (-t STDERR ? "\e[1;33m" : "" ), $self->ident, $_, (-t STDERR ? "\e[0m" : "" );
		}
	}
	$self->rbuf( defined( pos $buf ) ? substr($buf, pos $buf) : $buf );
	if (length $self->rbuf) {
		# warn "Leftover: ".$self->rbuf;
	}
	for my $line (@lines) {
		my $incoming;
		next if $line =~ /^\s*$/;
		#say $line;
		if( eval { $incoming = $JSON->decode($line); 1 } ) {
			$self->packet($incoming);
		} else {
			$self->log("Failed to decode incoming line: '$line': $@");
			close($self->fh);
			return;
		}
	}
	unless ($self->connected) {
		$self->on_eof();
	}
	return;
}

sub packet {
#	...
}

sub command {
	my $self = shift;
	my $command = shift;
	my $data = shift;
	$self->write({ v => $self->version, cmd => $command, data => $data });
}

sub write {
	my $self = shift;
	my $arg = shift;
	ref $arg or die "Bad argument to write";
    $arg->{time} ||= time;
	my $wbuf = $JSON->encode($arg);
	if ($self->netlog) {
		printf STDERR "%s>> %s %s%s\n", (-t STDERR ? "\e[1;34m" : "" ), $self->ident, $wbuf, (-t STDERR ? "\e[0m" : "" );
	}
	$wbuf .= "\n";
	while (length $wbuf) {
		my $wr = syswrite($self->fh, $wbuf);
		if ($wr) {
			# my $written = 
			substr($wbuf,0,$wr,'');
			# warn "written\n$written";
		}
		elsif ($! == Errno::EAGAIN) {
			sleep 0.01;
		}
		else {
			$self->log( "Connection error: $!" );
			$self->connected(0);
			last;
		}
	}
}


1;
