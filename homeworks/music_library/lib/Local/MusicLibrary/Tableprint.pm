package Local::MusicLibrary::Tableprint;

use strict;
use warnings;
use Data::Dumper;
use Exporter 'import';

our @EXPORT_OK = ('tableprint');

sub tableprint {					#\@database, \@columns, %hash
#	my %hash = ( 'band' => [0, 0],			#%hash{key}->[1] - maximum length in database +2;
#	'year' => [1, 0],
#	'album' => [2, 0],
#	'track' => [3, 0],
#	'format' => [4, 0]);
#	my %revhash = ( '0' => 'band',
#		'1' => 'year',
#		'2' => 'album',
#		'3' => 'track',
#		'4' => 'format');
	my %revhash;
	my @colnumb; 					#columns in numbers according to $hash{key}[0];
	my $curlength;
	my $namelength;
	my $sumlength;
	my $height;
	my ($dataref, $colref, %hash) = @_;
	for my $key (keys %hash) {
		$hash{$key} = [$hash{$key}, 0];
		$revhash{$hash{$key}[0]} = $key;
	}
	if ($$colref[0] eq '') {return 1;}
	unless (@$dataref) {return 1;}
#	for my $it (0..@$colref-1) {
#		unless (defined $hash{$$colref[$it]}) {
#			$hash{$$colref[$it]} = [$it, 0];
#			$revhash{$it} = $$colref[$it];
#		}
#	}
	for my $it (@$colref) {
		push @colnumb, $hash{$it}[0];
		$hash{$it}[1] = 1;			#means it will be printed
	}
	for my $key (keys %hash) {
		if ($hash{$key}[1] == 1) {
			my $number = $hash{$key}[0];
			for my $it1 (0..@$dataref-1) {
				$hash{$key}[1] = length $$dataref[$it1][$number] if length $$dataref[$it1][$number] > $hash{$key}[1];
			}
			$hash{$key}[1]+=2;
		}
	}
	for my $number (@colnumb) {
		$sumlength += $hash{$revhash{$number}}[1];
	}
	$sumlength = $sumlength+$#colnumb+2;
	$height = 2 * @$dataref + 1;
	for my $it (1..$height) {
		if ($it == 1) {
			print '/';
			print '-' x ($sumlength - 2);
			print '\\';
			next;
		}
		if ($it % 2 == 1 && $it != $height) {
			print '|';
			my $count = 0;
			for my $number (@colnumb) {
				$curlength = $hash{$revhash{$number}}[1];
				print '-' x $curlength;
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
		if ($it == $height) {
			print '\\';
#			for my $it1 (1..$sumlength-2) {
#				print '-';
#			}
			print '-' x ($sumlength-2);
			print '/';
			next;
		}
	} continue {$it++; print "\n";}
}
1;
