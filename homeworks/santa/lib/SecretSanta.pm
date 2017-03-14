package SecretSanta;

use 5.010;
use strict;
use warnings;
use DDP;

#  1 Рита Игорь
#  2 Вадим Катя
#  3 Али
#  4 Ира


sub calculate {
	my @members = @_;
	#my $ref1 = ['Рита', 'Игорь'];
	#my $ref2 = ['Вадим', 'Катя'];
	#my @members = ('Али', 'Ира', $ref1, $ref2); 
	my @res;
	my %presented;
	#my $n = scalar @members + scalar grep { ref($_) } @members;
	my %hash = map {@$_} grep{ ref($_) } @members;
        %hash =  (%hash, reverse map {@$_} grep{ ref($_) } @members );
	my @all = map {if (ref($_)) {@$_} else {$_}} @members;
	my %uniq;
	my @all_members = grep { !$uniq{$_}++ } @all;

	
	my $n = scalar @all_members;

#	print "@members\n";
#	p @members;
#	print '@all_members:'."\n";	
#	p @all_members;
	#print '%hash:'."\n";
	#p %hash;	
	for (my $i = 0; $i < $n; $i++) {
		print "$i\n";
		my $rand = int(rand($n));
		print "$rand\n";
		$presented { $all_members[$i] } = $all_members [ $rand ];
		if ( $presented{$all_members[$i]} eq  $all_members[$i] ){
			redo;
		} 
		if ( exists $hash{$all_members[$i]} and ($presented{$all_members[$i]} eq  $hash{$all_members[$i]})) {
			redo;
		}
#		if ( exists $presented { $all_members[$rand] } and   $presented { $all_members[$rand] }  eq  $all_members[$i] ) {
#                        redo;
#		}
#		p %presented;  
	
	
		push @res,[ "$all_members[$i]", "$presented{$all_members[$i]}" ];
	}
	#print '%presented:'."\n";
	#p %presented;
#	p @res;
	return @res;

}
#calculate;

1;
