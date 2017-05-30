#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS

Поиск номера первого ненулевого бита.

=head1 run ($x)

Функция поиска первого ненулевого бита в 32-битном числе (кроме 0).
Пачатает номер первого ненулевого бита в виде "$num\n"

Примеры: 

run(1) - печатает "0\n".

run(4) - печатает "2\n"

run(6) - печатает "1\n"

=cut

sub run {
    my ($x) = @_;
    my $num = 0;

    # ...
    # Вычисление номера первого ненулевого бита 
    for (my $del=1; $del<32; $del++) {
    	next if ($x % 2**$del!=0);
    	$num=$del;
    }
    # ...

    print "$num\n";
}

1;
