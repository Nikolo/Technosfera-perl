package Local::MusicLibrary::Options;

use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;
use Exporter 'import';

our @EXPORT = ('options');
my @sortfields = qw(band year album track format);

sub options {
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
	'columns=s')
	or return die ("wrong args");
	my $flag_sort = -1;
	my $flag_columns = -1;
	$flag_sort = 0 if $$hashref{sort} ne '';
	for $it (@sortfields){
		if ($$hashref{sort} eq $it) {
			$flag_sort = 1; 
			last;
		}
	}
	return 'Error sort' if !$flag_sort;
	return undef if @{$$hashref{columns}} && ${$$hashref{columns}}[0] eq '';	#--columns with no args => nothing to print
	unless (@{$$hashref{columns}}) {
		@{$$hashref{columns}} = @sortfields; 
		return undef;
	}
	if ($$hashref{columns}[0] ne '') {
		@{$$hashref{columns}} = split m/,/, $$hashref{columns}[0];
	} 
	else {return undef;}
	for $it (@{$$hashref{columns}}) {
		$flag_columns = 0;
		for $it1 (@sortfields) {
			$flag_columns = 1 if $it eq $it1;
		}
		if (!$flag_columns) {return 'Error col'};
	}
#	if ($flag_columns == -1) { @{$$hashref{'columns'}} = @sortfields };
	return undef;
}

1;
