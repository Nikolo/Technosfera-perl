package Local::MusicLibrary::Paint;

use strict;
use warnings;
BEGIN {if($]<5.018){package experimental; use warnings::register;}} no warnings 'experimental';

use List::Util qw(reduce);

=encoding utf8

=head1 NAME

Local::MusicLibrary::OptionTools - music library module is responsible for printing data

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS
	
	# Paint your @table with widths of columns in @widths
    Local::MusicLibrary::Paint->paint(result => @table, widths => @widths);

=cut

sub paint {
	shift;
	my $result = $_[0]->{result};
	my $max_len_strs = $_[0]->{widths};
	return if (not defined $result->[0] or not defined $max_len_strs->[0]);
	my $width = (reduce { $a + $b } @$max_len_strs) + @$max_len_strs * 3 - 1;
	printf("/\%s\\\n", "-"x$width);
	my $format_str = (join '', map { sprintf('| %%%ds ', $_) } @$max_len_strs) . "|\n";
	my $separator = '|' . (join '+', map { sprintf('-%s-', '-'x$_) } @$max_len_strs) . "|\n";
	print join($separator, map { sprintf($format_str, @$_) } @$result);
	printf("\\\%s/\n", "-"x$width);
}

1;
