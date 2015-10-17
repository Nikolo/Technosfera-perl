package Sfera::TCP::Calc;

use strict;

sub TYPE_CALC         {1}
sub TYPE_NOTATION     {2}
sub TPYE_BRACKETCHECK {3}

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
	my $message = shift;
	...
}

sub unpack_message {
	my $pkg = shift;
	my $message = shift;
	...
}

1;
