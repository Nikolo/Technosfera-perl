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

    for(my $i = $str.length; $i >= $substr.length;$i--){
	if($str[i]==$substr[0]){
		my $c = 0;
		while($c<$substr.length){
			if($str[$c+$i]==$substr[$c]){
				if($c==(($substr.length) - 1)){$num++;}
				$c++;
			}else{$c=$substr.length;}	
		}
	}
    print "$num\n";
    }
}
1;
