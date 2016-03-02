package Local::Hackathon::Worker;

use Mouse;
use Carp;
use Local::Hackathon::Client;
use DDP;

has 'client',       is =>'rw', default => sub { Local::Hackathon::Client->new() };

has 'source',       is => 'rw', required => 1;
has 'destination',  is => 'rw', required => 1;


sub import {
	my $pkg = shift;
	my $rolename = shift;
	$rolename or croak "Role name required";
	my $role = $pkg . '::' . ucfirst lc $rolename;
	Mouse::Util::apply_all_roles( $pkg, $role );
}

sub run {
	my $self = shift;
	warn "run from ".$self->source." to ".$self->destination;
	my $working = 0;
	$SIG{INT} = $SIG{TERM} = sub {
		exit unless $working;
		undef $working;
	};	
	while (defined $working) {
		$working = 1;
		my $data = $self->client->take( $self->source );
		unless ($data) {
			warn sprintf "No tasks for '%s'\n", $self->source;
			$working = 0;
			sleep 1;
			next;
		}
		p $data;
		my $id = $data->{id};
		my $task = $data->{task};
		p $task;
		eval {
			my $newtask = $self->process($task);

			warn "Doing requeue";
			my $req = $self->client->requeue( $id, $self->destination, $newtask );

			p $req;

		1} or do {
			my $err = "$@";
			warn "Error on processing task: $err";
			$self->client->release($id);
		};
		$working = 0;
	}
}

sub process {
	my $self = shift;
	my $task = shift;
	# ...
	return $task;
}

1;