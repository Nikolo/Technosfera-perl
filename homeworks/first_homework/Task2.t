cat 123.txt | perl -lnaF';' -e 'if ($F[4]>1048576){print $F[8];$i++;};}{ print "Total number of strings is ".$.." Number of right strings is ".$i'

