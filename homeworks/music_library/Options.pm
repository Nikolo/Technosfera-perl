package Local::Options;

use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;
use Exporter 'import';

our @EXPORT = ('Options');
my @sortfields = ('band', 'year', 'album', 'track', 'format');

sub Options {
	my $hashref = shift;
	my $it;
	my $it1;
	GetOptions($hashref, 
	'band=s',
	'year=s',
	'album=s',
	'track=s',
	'format=s',
	'sort=s',
	'columns:s{,}')
	or return exit;
	my $flag_sort = -1;
	my $flag_columns = -1;
	$flag_sort = 0 if $$hashref{'sort'} ne '';
	for $it (@sortfields){
		if ($$hashref{'sort'} eq $it) {$flag_sort = 1; last;}
	}
	return 'Error sort' if (!$flag_sort);
	if (@{$$hashref{'columns'}} and ${$$hashref{'columns'}}[0] eq '') { return exit;}	#--columns with no args => nothing to print
	for $it (@{$$hashref{'columns'}}) {
		$flag_columns = 0;
		for $it1 (@sortfields) {
			$flag_columns = 1 if $it eq $it1;
		}
		if (!$flag_columns) {return 'Error col'};
	}
	if ($flag_columns == -1) { @{$$hashref{'columns'}} = @sortfields };
	return undef;
}

1;

