package Local::TCP::Calc;

use strict;

sub TYPE_START_WORK {1}
sub TYPE_CHECK_WORK {2}
sub TYPE_CONN_ERR   {3}
sub TYPE_CONN_OK    {4}

sub STATUS_NEW   {1}
sub STATUS_WORK  {2}
sub STATUS_DONE  {3}
sub STATUS_ERROR {4}

sub pack_header {
	my $pkg = shift;
	my $type = shift;
	my $size = shift;
	...
}

sub unpack_header {
	my $pkg = shift;
	my $header = shift;
	...
}

sub pack_message {
	my $pkg = shift;
	my $messages = shift;
	...
}

sub unpack_message {
	my $pkg = shift;
	my $message = shift;
	...
}

1;
