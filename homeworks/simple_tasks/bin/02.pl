#!/usr/bin/perl
use strict;
use warnings;
sub run {
    my ($x, $y) = @_;
    for (my $i = $x; $i <= $y; $i++) {
		my $flag = 1;
	for(my $o = 2; $o <= $i; $0++){
		if($i%$o != 0){$flag = 0;}
}
	if($flag == 1){print "$i\n";}
    }
}

