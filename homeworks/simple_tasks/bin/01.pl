#!/usr/bin/perl
use strict;
use warnings;
sub run {
    my ($a, $b, $c) = @_;
    my $x1 = undef;
    my $x2 = undef;

	if(($a != 0)&&($b*$b - 4*$a*$c>0)){
	my $dis = sqrt( $b*$b - 4*$a*$c);

	$x1 = ((-1)*$b+$dis)/(2*$a);
	$x2 = ((-1)*$b-$dis)/(2*$a);
	 print "$x1, $x2\n";
}else{
	print "No solution!\n";
}

}


