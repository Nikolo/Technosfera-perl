#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS

Поиск номера первого не нулевого бита.

=head1 run ($x)

Функция поиска первого не нулевого бита в 32-битном числе (кроме 0).
Пачатает номер первого не нулевого бита в виде "$num\n"

Примеры: 

run(1) - печатает "0\n".

run(4) - печатает "2\n"

run(6) - печатает "1\n"

=cut

sub run {
    my ($x) = @_;
    my $num = 0;
	if($x==0){
	return;
	}
	while(1){
	if ($x%2 ==0){
	
	$x=($x)/2;
		$num++;
	
	}else {
		print "$num\n";
	 	last;
	}
	}
   
}

1;
