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
    for (my $i = $x; $i <= $y; $i++) {

        # ...
        # Проверка, что число простое
        # ...
        if ($i == 2){
            print "$i\n";
        }


        if ($i > 2) # proverka na 1+
        {   
            my $las = 0;
            for (my $pis = 2; $pis < $i; $pis++){
                if ($i % $pis == 0){
                   $las = 1;
                } elsif ($pis == ($i-1) and $las == 0){                    
	                print "$i\n";
                }
            }
        }


    }
}

1;
