#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS

Вычисление простых чисел

=head1 run ($x, $y)

Функция вычисления простых чисел в диапазоне [$x, $y].
Пачатает все положительные простые числа в формате "$value\n"
Если простых чисел в указанном диапазоне нет - ничего не печатает.

Примеры: 

run(0, 1) - ничего не печатает.

run(1, 4) - печатает "2\n" и "3\n"

=cut

sub run {
    my ($x, $y) = @_;
my $X=$x;
my $Y=$y;

my $i=$X;
my $j;
my $flag;
	while ($i++<$Y) {
	if($i ==-1 || $i==0|| $i== 1){
		next;
	}
		$j=1;
		$flag =1;
		while(++$j<$i){
			if($i%$j == 0){
				$flag =0;
				last;
			
			}
		}
		if($flag==1){
			print "$i\n";
		}
	}

}   

1;
