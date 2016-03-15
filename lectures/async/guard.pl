use strict;
use 5.010;
#use Guard;

sub Guard::DESTROY {
	my $self = shift;
	$self->[0]->() if $self->[0];
}
sub Guard::cancel {
	$_[0][0] = undef;
}
sub guard(&) {
	my $cb = shift;
	bless [$cb],'Guard';
}

my $guard = guard {
	say '$guard was unrefed';
};
say "Before";
undef $guard;
say "After";
