#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS

Поиск количества вхождений подстроки в строку.

=head1 run ($str, $substr)

Функция поиска количества вхождений строки $substr в строку $str.
Пачатает количество вхождений в виде "$count\n"
Если вхождений нет - печатает "0\n".

Примеры: 

run("aaaa", "aa") - печатает "2\n".

run("aaaa", "a") - печатает "4\n"

run("abcab", "ab") - печатает "2\n"

run("ab", "c") - печатает "0\n"

=cut

sub run {
    my ($str, $substr) = @_;
    my $num = 0;
    my @array;
 
    # ...
    # Вычисление количества вхождений строки $substr в строку $str,
    # ...
    @array = $str=~/($substr)/g; # g - global searh.
    $num = scalar @array; # return the value of EXPR (perldoc).

    print "$num\n";
}

1;
