use strict;
use warnings;




my $pisos = "pisospis";

my $num = 0;
while ( $pisos =~ "pis"){

    $pisos =~s/pis/sos/;


    $num++;
}


printf $num;
