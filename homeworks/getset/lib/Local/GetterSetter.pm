package Local::GetterSetter;

use strict;
use warnings;
no strict 'refs';

sub import {
(my $package, my $filename, my $line) = caller(1);
for my $key (@_) {
	my $strset = $package.'::'."set_$key";
	*{$strset} = sub {
		${*{$package.'::'.$key}} = shift;
	};
	my $strget = $package.'::'."get_$key";
	*{$strget} = sub {
		  return ${*{$package.'::'.$key}};
	};
	}
}
1;
