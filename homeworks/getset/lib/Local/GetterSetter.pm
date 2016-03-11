package Local::GetterSetter;

use strict;
use warnings;
use Data::Dumper; 
sub import {
	shift;
	my ($package, $filename, $line) = caller();
	for my $key (@_) {
		no strict 'refs';
		*{$package.'::'."set_$key"} = sub {
			${$package.'::'.$key} = shift;
		};
		
		*{$package.'::'."get_$key"} = sub {
		  	return ${$package.'::'.$key};
		};
	}
}
1;
