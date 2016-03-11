package Local::GetterSetter;

use strict;
use warnings;

sub import {
	no strict 'refs';
	my ($package, $filename, $line) = caller();
	for my $key (@_) {
		print "$key\n";
		*{$package.'::'."set_$key"} = sub {
			${$package.'::'.$key} = shift;
		};
		
		*{$package.'::'."get_$key"} = sub {
		  	return ${$package.'::'.$key};
		};
	}
}
1;
