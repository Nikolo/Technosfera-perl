package Local::Chat::Room;

use 5.010;
use strict;
use Mouse;
BEGIN {if($]<5.018){package experimental; use warnings::register;}} no warnings 'experimental';

has 'name',   is => 'ro', required => 1, trigger => sub {
	my $self = shift;
	$_[0] =~ m{^#\w+$} or die "Bad room name";
};
has 'reg',    is => 'ro', default => sub {{}};
has 'server', is => 'rw', required => 1;

sub log {
	my $self = shift;
	my $msg;
	if (@_ > 1 and index($_[0],'%') > -1) {
		$msg = sprintf $_[0],@_[1..$#_];
	} else {
		$msg = "@_";
	}
	printf STDERR "[%s] %s\n", $self->name, $msg;
}

sub all {
	my $self = shift;
	return values %{ $self->reg };
}

sub join : method {
	my $self = shift;
	my $client = shift;
	$self->reg->{ $client->remote } = $client;
	for my $c ($self->all) {
		$c->event("join", { nick => $client->nick, to => $self->name });
	}
	$client->rooms->{ $self->name } = $self;
}

sub remove {
	my $self = shift;
	my $client = shift;
	if( my $c = $self->reg->{ $client->remote } ) {
		warn "found $c in ",$self->name;
		delete $self->reg->{ $client->remote };
		for my $c ($self->all) {
			$c->event("part", { nick => $client->nick, to => $self->name });
		}
	}
}

sub have {
	# check if room have client
	my $self = shift;
	my $client = shift;
	return exists $self->reg->{ $client->remote };
}

sub names {
	my $self = shift;
	my @names = sort map { $_->nick } $self->all;
	return \@names;
}

sub message {
	my $self = shift;
	my $data = shift;
	$data->{to} = $self->name;
	for my $c ($self->all) {
		$c->message($data);
	}
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

1;
