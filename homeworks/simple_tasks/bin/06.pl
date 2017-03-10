#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS

Шифр Цезаря https://ru.wikipedia.org/wiki/%D0%A8%D0%B8%D1%84%D1%80_%D0%A6%D0%B5%D0%B7%D0%B0%D1%80%D1%8F

=head1 encode ($str, $key)

Функция шифрования ASCII строки $str ключем $key.
Пачатает зашифрованную строку $encoded_str в формате "$encoded_str\n"

Пример:

encode('#abc', 1) - печатает '$bcd'

=cut


sub encode {
    my ($str, $key) = @_;
    my $encoded_str = '';
    my $n = 128;
    for (my $i = 0; $i < length($str); $i++) {
	my $index =ord(substr($str, $i, 1));
	substr($encoded_str, $i, 1) = chr((($index + $key + 1) % $n)-1) 	
    }
    print "$encoded_str\n";
}

=head1 decode ($encoded_str, $key)

Функция дешифрования ASCII строки $encoded_str ключем $key.
Пачатает дешифрованную строку $str в формате "$str\n"

Пример:

decode('$bcd', 1) - печатает '#abc'

=cut

sub decode {
    my ($encoded_str, $key) = @_;
    my $str = '';
    my $n = 128;
    for (my $i = 0; $i < length($encoded_str); $i++) {
         my $index = ord(substr($encoded_str, $i, 1));
         substr($str, $i, 1) = chr(($index - $key + $n) % $n) 
    }
    print "$str\n";
}
encode('#abc',1);
1;

