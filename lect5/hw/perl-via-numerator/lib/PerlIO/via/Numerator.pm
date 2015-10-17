package PerlIO::via::Numerator;

use strict;
use Fcntl 'SEEK_CUR';

sub PUSHED {
	my ($class,$mode) = @_;
	my $obj = {fh => undef, mode => undef, ...};
	if($mode eq 'w'){
		$obj->{mode} = '>';
	}
	elsif($mode eq 'r'){
		$obj->{mode} = '<';
	}
	else {
		die $mode." not supported in PerlIO::via::Numerator";
	}
	return bless $obj,$class;
}

sub OPEN {
	my ($obj,$path,$mode) = @_;
	open or sysopen ...
}

sub FILL {
	my ($obj) = @_;
	my $fh = $obj->{fh};
	...
}

sub READ {
	my ($buffer,$len) = @_;
	my $fh = $obj->{fh};
	...
}

sub WRITE {
	my ($obj,$buf) = @_;
	$obj->{buf} .= ...
}

sub FLUSH {
	my ($obj) = @_;
	my $fh = $obj->{fh};
	...
}

1;
