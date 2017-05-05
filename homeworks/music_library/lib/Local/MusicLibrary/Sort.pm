package Local::MusicLibrary::Sort;
use strict;
use warnings;
use feature 'switch';
use Exporter 'import';

our @EXPORT_OK = ('Sort');

sub Sort {
	no warnings 'experimental';
	my ($dataref, $sort, %hash) = @_;
	if ($sort eq '') {return -1;}
	given ($hash{$sort}[1]) {
		when ('int') {
			@$dataref = sort {$a->[$hash{$sort}[0]] <=> $b->[$hash{$sort}[0]]} @$dataref;
		}
		when ('str') {
			@$dataref = sort {$a->[$hash{$sort}[0]] cmp $b->[$hash{$sort}[0]]} @$dataref;
		}
	}
	return $hash{$sort}[0];
}
1;
