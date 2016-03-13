package Local::Sort;
use strict;
use warnings;
#use feature 'switch';
use Exporter 'import';

our @EXPORT = ('Sort');

sub Sort {
	my ($dataref, $sort) = @_;
	my %hash = ( 'band' => 1,
		'year' => 2,
		'album' => 3,
		'track' => 4,
		'format' =>5);
	if ($sort eq '') {return -1;}
	if ($sort eq 'year') {
		@$dataref = sort {$a->[1] <=> $b->[1]} @$dataref;
		return 1;
	}
	@$dataref = sort {$a->[$hash{$sort}-1] cmp $b->[$hash{$sort}-1]} @$dataref;
	return $hash{$sort};
}
1;
