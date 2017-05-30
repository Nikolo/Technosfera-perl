#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS

Поиск количества вхождений строки в подстроку.

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
    my $pos = 0;
    # ...
    # Вычисление количества вохождений строки $substr в строку $str,
    if (index($str, $substr, $pos) == -1) {
	print "0\n";
    }
    else {
    	while (index($str, $substr, $pos) != -1 && $pos+length($substr) <= length ($str)) { 
			$pos = index($str, $substr, $pos) + length($substr);
#			print "$pos\n";
			$num ++;
    	}
#    $num = length($str);
    }
    # ...

    print "$num\n";
}
run("abcab","ab");

1;
