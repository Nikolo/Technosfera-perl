ls -l | perl -e '$/="\n"; while(<>){chomp;@ar=split(" ");$i=0;while($i<=7){print "$ar[$i];"; $i++;} if ($#ar==7) {print "\n";} else {while ($i<=$#ar) {print "$ar[$i] "; $i++;}print "\n";}}'  > 123.txt


