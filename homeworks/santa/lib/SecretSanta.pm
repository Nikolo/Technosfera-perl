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
	for my $var (0..$#members + scalar grep { ref($_) } @members) {
		print "$var\n";  
	}
	# ...
	#	push @res,[ "fromname", "toname" ];
	# ...
	#return @res;
	print "@members\n";
	my %hash = map {@$_} grep{ ref($_) } @members;
	print values %hash;

}
calculate;

1;
