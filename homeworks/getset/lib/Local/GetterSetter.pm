package Local::GetterSetter;

use strict;
use warnings;
use Data::Dumper; 
sub import {
	my ($class, @vars) = @_;
	my ($package, $filename, $line) = caller();
	for my $key (@vars) {
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
