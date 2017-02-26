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
    my $conste = 1;
    my $flag = 1;
    print "\n" if $x<1;
	# ...
        # Проверка, что число простое
        # ...
    if ($x>=1)
    {
	if($x==1)
        {
          $x++;
        }
     for (my $i = $x; $i <= $y; $i++) {
      $flag = 1;
      for (my $j = $x; $j<$i; $j++) {
        if ($i%$j == 0 && $i%$conste == 0) {
        $flag = 0; # check conditions.
        }
      }
        print "$i\n" if $flag;  
     }
     }
        
	
}

1;
