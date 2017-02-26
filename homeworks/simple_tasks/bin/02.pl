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
    my $simple = undef;
    for (my $i = $x; $i <= $y; $i++) {
    	if ($i <= 0) { $simple = 0; }
    	elsif ($i == 1) { $simple = 0; } 
    	elsif ($i == 2) { $simple = 1; }
    	elsif ($i % 2 == 0) { $simple = 0; }
    	else {
    		my $t = 3;
    		$simple = 1;
    		while ( ($t * $t <= $i) && $simple == 1) {
    			if ($i % $t == 0) { $simple = 0; }
    			else { $t = $t + 2; }
    		}
    	}
    	if ($simple == 1) { print "$i\n"; }
    }
}

1;
