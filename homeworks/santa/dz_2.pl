use strict;
use warnings;
use 5.18.0;
use Data::Dumper;
use PadWalker;

my @members = (['A','B'],['C','D'],'E','F');
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

say $dlina;
my $from_name; 
my $to_name;
my $randomik;
my $sub_randomik;
my $flag_1 = 0;

for(my $i = 0; $i < $dlina; $i++){              # цикл для расчёта реального кол-ва элементов

    $dlina = scalar @members;

    if (ref($members[$i]) eq "ARRAY"){          # проверка на массивность каждого элемента 
        print "Element $i is Array\n";
        

        for (my $j = 0; $j < 2; $j++){          # прохождение для каждого из двух элементов в списке
            $from_name = $members[$i][$j];        # от кого подарок

            while($flag_1 == 0){                # там генерируется рандом
            
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
        }
        
    } else{
        print "Element $i is not Array\n";
        

         $from_name = $members[$i];             # от кого подарок

            while($flag_1 == 0){                # там генерируется рандом
            
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

    }
   
    
}
#say $dlina;
my $pis = $members[0];      # ясделаль!! 
my $sas = @$pis;            # подсчёт кол-ва элементов вложенного массива!!
#say $sas;
#say $members[0][0];

#push (@ to_mas ,1,2);
#say @to_mas;
#my $link = \@to_mas;
#push (@ to , $link);
#say @to;

print Dumper @res;