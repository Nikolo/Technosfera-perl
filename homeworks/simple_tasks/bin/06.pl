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
	
  decode($str, 0x7F+1-$key%128);

    
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
	


my @strList = split ('',$encoded_str);

if ($key<0){
	return;
}
 
my $i=0;
while ($i++<$key){
	if(shiftOneTime(@strList)==0){
		$i=-1;
		last;
	}

}

if ($i!=-1){
	$str=join('',@strList);
	print "$str\n";
	
}

 

    
}
sub shiftOneTime{
for(@_){

	if (ord($_) > 0x7F || ord($_)<0){
		return 0; # недопустимые символы в строке
		last;
	}

	if (ord($_) == 0){
		$_ = chr(0x7F);
		next;
	}
	
	$_=chr(ord($_)-1);	
}
return 1;
}
1;
