use strict;
use warnings;



 my $str = "sas sas sas";
 my $substr = "sas";
    my $num = 0;

    # ...
    # Вычисление количества вохождений строки $substr в строку $str,
    # ...

    while($str=~$substr){

        $str=~s/$substr//; #в принципе работает если заменить длинный текст на пробел
        $num++;

    }



    print "$num\n";