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
	my $flag =0;
	while($flag!=1){
		if($x%2==0){$num++;$x/=2;}
		else{$flag=1;}	

	}
   

    print "$num\n";
}

1;
