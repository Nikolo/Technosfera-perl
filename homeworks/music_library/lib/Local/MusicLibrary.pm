package Local::MusicLibrary;

use strict;
use warnings;
use Local::MusicLibrary::Filter qw(filter);
use Local::MusicLibrary::Options qw(options);
use Local::MusicLibrary::Sort qw(Sort);
use Local::MusicLibrary::Tableprint qw(tableprint);
use Exporter 'import';

our @EXPORT_OK = ('printlibrary');


sub printlibrary {
	my $sort;
	my @columns;
	my $errcheck;
	my %parameters = (
		band => '',
		year => '',
		album => '',
		track => '',
		format => '',
		sort => '',
		columns => \@columns);
	my %hash = (
		band => [0, 'str'],
		year => [1, 'int'],
		album => [2, 'str'],
		track => [3, 'str'],
		format => [4, 'str']);
	my @database; 					#arrays of arrays such as band:year:album:track:format
	$errcheck = options(\%parameters);
	die ($errcheck) if defined $errcheck;
	filter(\@database, \%parameters, %hash);
	$sort = $parameters{sort};
	Sort(\@database, $sort, %hash);
	tableprint(\@database, \@columns, %hash);
}
1;
