package Local::Tableprint;

use strict;
use warnings;
use Exporter 'import';

our @EXPORT = ('Tableprint');

sub Tableprint {					#\@database, \@columns
	my %hash = ( 'band' => [0, 0],			#%hash{key}->[1] - maximum length in database +2;
	'year' => [1, 0],
	'album' => [2, 0],
	'track' => [3, 0],
	'format' => [4, 0]);
	my %revhash = ( '0' => 'band',
		'1' => 'year',
		'2' => 'album',
		'3' => 'track',
		'4' => 'format');
	my @colnumb; 					#columns in numbers according to %hash{key}->[0];
	my $curlength;
	my $namelength;
	my $sumlength;
	my $sumwidth;
	my ($dataref, $colref) = @_;
	for my $it (@$colref) {
		push @colnumb, $hash{$it}[0];
		$hash{$it}[1] = 1;			#means it will be printed
	}
	for my $key (keys %hash) {
		if ($hash{$key}[1] == 1) {
			my $number = $hash{$key}[0];
			for my $it1 (0..@$dataref-1) {
				if (length $$dataref[$it1][$number] > $hash{$key}[1]) {$hash{$key}[1] = length $$dataref[$it1][$number];}
			}
			$hash{$key}[1]+=2;
		}
	}
	for my $number (@colnumb) {
		$sumlength += $hash{$revhash{$number}}[1];
	}
	$sumlength = $sumlength+$#colnumb+2;
	$sumwidth = 2 * @$dataref + 1;
	for my $it (1..$sumwidth) {
		if ($it == 1) {
			print '/';
			for my $it1 (1..$sumlength-2) {
				print '-';
			}
			print '\\';
			next;
		}
		if ($it % 2 == 1 and $it != $sumwidth) {
			print '|';
			my $count = 0;
			for my $number (@colnumb) {
				$curlength = $hash{$revhash{$number}}[1];
				for (1..$curlength) {print '-';}
				if ($count == $#colnumb) {print '|';}
				else {print '+';}
			} continue {$count++;}
			next;
		}
		if ($it % 2 == 0) {
			print '|';
			for my $number (@colnumb) {
				$namelength = length $$dataref[int($it/2)-1][$number];
				$curlength = $hash{$revhash{$number}}[1];
				for my $it2 (1..$curlength) {
					if ($namelength +1 == $curlength -$it2 +1 ) {
						print $$dataref[int($it/2)-1][$number]; 
						last;
					}
					print ' ';
				}
				print ' |';
			}
		}
		if ($it == $sumwidth) {
			print '\\';
			for my $it1 (1..$sumlength-2) {
				print '-';
			}
			print '/';
			next;
		}
	} continue {$it++; print "\n";}
}
1;
