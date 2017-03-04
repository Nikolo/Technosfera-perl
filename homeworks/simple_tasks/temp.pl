use strict;
use warnings;




my $pisos = 0xffff0508;

my $num = 0;
while ($pisos % 0b10 == 0){
    $pisos = $pisos / 0b10 ;
    $num++;
}


printf $num;
