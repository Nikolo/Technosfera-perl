#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS

Поиск наименьшего и наибольшего из 3-х чисел

=head1 run ($x, $y, $z)

Функция поиска минимального и максимального из 3-х чисел $x, $y, $z.
Пачатает минимальное и максимальное числа, в виде "$value1, $value2\n"

Примеры: 

run(1, 2, 3) - печатает "1, 3\n".2 1 -1

run(1, 1, 1) - печатает "1, 1\n"

run(1, 2, 2) - печатает "1, 2\n"

=cut

sub run {
    my ($x, $y, $z) = @_;
    my $min = $x;
    my $max = $x;

   if($x<$y){if($y<$z){$max=$z;$min = $x;}
	else{$max=$y;if($x<$z){$min=$x;}else{$min=$z;}}}
   else{if($x<$z){$max=$z;$min = $y;}
	else{$max=$x;if($y<$z){$min=$y;}else{$min=$z;}}}
    print "$min, $max\n";
}

1;
