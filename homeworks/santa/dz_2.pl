use strict;
use warnings;
use 5.18.0;
use Data::Dumper;
use PadWalker;

my @members = ('K',['A','B']);
my @res;
#my @all = ("Ivan", "Alex", "Anna",);
#my @fam = ("pis","sas");

#my $link = \@fam;

#my $los = 1;
#my $name = "los";

#push @all, $link;

#say foreach @all;



my $dlina = scalar @members;                    # пилим подсчёт кол-ва элементов в массива
my @to_mas;
my @to;

my $from_name; 
my $to_name;
my $randomik;
my $sub_randomik;
my $flag_1 = 0;
my $count = 0;



for(my $i = 0; $i < $dlina; $i++){              # цикл для расчёта реального кол-ва элементов

if ($dlina == 1 && ref($members[0]) eq "ARRAY"){
    last;
}
    $dlina = scalar @members;

    if (ref($members[$i]) eq "ARRAY"){          # проверка на массивность каждого элемента 
     
        for (my $j = 0; $j < 2; $j++){          # прохождение для каждого из двух элементов в списке
            $from_name = $members[$i][$j];        # от кого подарок

            while($flag_1 == 0){                # там генерируется рандом
                $count++;

                if ($count>1000){
                        last;
                    }

                $randomik = int(rand($dlina));
               
                if($randomik != $i){            # проверка на неравенство нынешнему номеру I 
                    
                    if (ref($members[$randomik]) eq "ARRAY"){ # если выбранный элемент - массив 
                        $sub_randomik = int(rand(2));
                        $to_name = $members[$randomik][$sub_randomik];
                    }else{
                        $to_name = $members[$randomik];
                    }
                    $flag_1=1;                  # установка флага 
                    
                    my $k = 0;
                    while($k != scalar @res){   # там проверка на наличие такого же избраннрика в массиве рес 
                        my $pis = 1;
                        if($res[$k][$pis] eq "$to_name"){ # сама проверка, собственно
                            $flag_1=0;
                        }

                        $k++;
                    }
                    if($flag_1==1){             # если всё ок, засунь элемент в рес
                        push @res,[$from_name,$to_name];
                    }
                    
                } 

            }
            $flag_1 = 0;
            if ($count>1000){last;}
        }
        
    } else{
        
       
         $from_name = $members[$i];             # от кого подарок

            while($flag_1 == 0){                # там генерируется рандом
             $count++;
            if ($count==1000){
                        say "Nope";
                        last;
                    }

                $randomik = int(rand($dlina));
               
                if($randomik != $i){            # проверка на неравенство нынешнему номеру I 
                    
                    if (ref($members[$randomik]) eq "ARRAY"){ # если выбранный элемент - массив 
                        $sub_randomik = int(rand(2));
                        $to_name = $members[$randomik][$sub_randomik];
                    }else{
                        $to_name = $members[$randomik];
                    }
                    $flag_1=1;                  # установка флага 
                    
                    my $k = 0;
                    while($k != scalar @res){   # там проверка на наличие такого же избраннрика в массиве рес 
                        my $pis = 1;
                        if($res[$k][$pis] eq "$to_name"){ # сама проверка, собственно
                            $flag_1=0;
                        }

                        $k++;
                    }
                    if($flag_1==1){             # если всё ок, засунь элемент в рес
                        push @res,[$from_name,$to_name];
                    }
                } 
            }
            $flag_1 = 0;
            if ($count>1000){last;}
    }
   
    
}
#say $dlina;
#my $pis = $members[0];      # ясделаль!! 
#my $sas = @$pis;            # подсчёт кол-ва элементов вложенного массива!!
#say $sas;
#say $members[0][0];

#push (@ to_mas ,1,2);
#say @to_mas;
#my $link = \@to_mas;
#push (@ to , $link);
#say @to;
if ($count>1000){push @res, 'not all'}
print Dumper @res;