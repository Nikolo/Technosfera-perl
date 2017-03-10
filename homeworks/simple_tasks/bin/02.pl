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
    OUTER:
    for (my $i = $x; $i <= $y; $i++) {

        # ...
        # Проверка, что число простое
        next if ($i % 2==0 && $i!=2 || $i < 2);
        for (my $del=3; $del <= sqrt($i); $del+=2) {
        	if ($i % $del==0) {
        		next OUTER;
        	}
        }
        # ...

	print "$i\n";
    }
}

1;