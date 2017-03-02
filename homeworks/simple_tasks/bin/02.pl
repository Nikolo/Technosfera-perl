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

sub simpleTest{
my $x =@_;
unless($x < 2){
for (my $i = 2; $i<$x ;++$i){
if(($x % $i) == 0){return;}
}
print  $x;
}
}
sub run {
    my ($x, $y) = @_;
    for (my $i = $x; $i <= $y; $i++) {

        # ...
        # Проверка, что число простое
        # ...
	

	simpleTest($i);
    }
}

1;
