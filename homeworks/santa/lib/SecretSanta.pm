package SecretSanta;

use 5.010;
use strict;
use warnings;
#use DDP;

sub calculate {
	my @members = @_;
    my @good;
	my @res;
    my @men;
    my @women;
    my @alone;
    for my $i  (0...$#members)
    {
        if(ref($members[$i]) eq "ARRAY")
                {
                    push @men, $members[$i][0];
                    push @women, $members[$i][1];
                }
        else
        {
            push @alone, $members[$i];
        }

    }
    push @good, pop @alone;
    push @good, @men;
    push @good, @alone;
    push @good, @women;

    for my $j (0...$#good-1)
    {
        push @res,[$good[$j],$good[$j+1]];
    }
    
    push @res, [$good[$#good],$good[0]];

	# ...
	#	push @res,[ "fromname", "toname" ];
	# ...
	return @res;
}

1;
