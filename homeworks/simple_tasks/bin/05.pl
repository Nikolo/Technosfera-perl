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

 my $inputString = $str;
chomp $inputString;
my $subString = $substr;
chomp $subString;
if (length($subString) > length($inputString)){
	return 0; #ошибка, строка мешьне чем подстрока
}
my $count=0;
my $index=0;
while ( ($index=index($inputString,$subString, $index)) != -1 ){
	$index++;
	$count++;
}

    print "$count\n";
}

1;
