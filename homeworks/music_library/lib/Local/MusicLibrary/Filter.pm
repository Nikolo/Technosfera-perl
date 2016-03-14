package Local::MusicLibrary::Filter;

use strict;
use warnings;
use feature 'switch';
use Exporter 'import';
our @EXPORT_OK = ('filter');

sub parser {									#Parser($string, \@record)
	my ($string, $aref) = @_;
	my @temprec = split m/\.?\/+/, $string;					#band:year - album:track.format
	my $extra = shift @temprec;						#@temprec[0] = ''; shifting it;
	my ($year, $album) = split m/\s*\-\s*/, $temprec[1], 2;
	my ($track, $format) = split m/\./, $temprec[2];
	$$aref[0] = $temprec[0];
	$$aref[1] = $year;
	$$aref[2] = $album;
	$$aref[3] = $track;
	$$aref[4] = $format;
}

sub filter {									#Filter(\@database, \%parameters, %hash);
	my $it = 0;
	my $flag = 0;
	my $number;
	my @record;
	my ($dataref, $paramref, %hash) = @_;
	while (<>){
		chomp;
		$flag = 0;
		parser($_, \@record);
		if ($#record < 4) {next;}
		for my $key (keys %hash) {
			no warnings 'experimental';
			given ($hash{$key}[1]) {
				when ('int') {
					if ($$paramref{$key} ne '' && $record[$hash{$key}[0]] != $$paramref{$key}) {
						$flag = 1;
						last;
					}
				}
				when ('str') {
					if ($$paramref{$key} ne '' && $record[$hash{$key}[0]] ne $$paramref{$key}) {
						$flag = 1;
						last;
					}
				}
			}
		}
		next if $flag;
		push @$dataref, [@record];
		$it++;
	}
}
1;
