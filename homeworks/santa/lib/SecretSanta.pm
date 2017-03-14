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
#	my @members = @_;
	my $ref1 = ['Рита', 'Игорь'];
	my $ref2 = ['Вадим', 'Катя'];
	my @members = ('Али', 'Ира', $ref1, $ref2); 
	my @res;
	my %presented;
	my $n = scalar @members + scalar grep { ref($_) } @members;
	my %hash = map {@$_} grep{ ref($_) } @members;
        %hash =  (%hash, reverse map {@$_} grep{ ref($_) } @members );
	for (my $i=0; $i < $n; $i++) {
		print "$i\n";
		$presented {$i} = rand($n);
		if ($presented{$i} == $i i or %hash) {
			redo;
		} 
#		p %presented;  
	}
	# ...
	#	push @res,[ "fromname", "toname" ];
	# ...
	#return @res;
	print "@members\n";
	my %hash = map {@$_} grep{ ref($_) } @members;
	%hash =  (%hash, reverse map {@$_} grep{ ref($_) } @members );
	my @arr = %hash;
	p %hash;
	print "@arr\n";
	my @a = 1 .. 2;
	my @b = 45 ..100;

	my %chk;
	@chk{@a} = (1, 2);
	p %chk;
	p %presented;
}
calculate;

1;
