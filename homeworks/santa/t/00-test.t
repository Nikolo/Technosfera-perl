#!/usr/bin/env perl

use 5.010;  # for say, given/when
use strict;
use warnings;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';
our $VERSION = 1.0;

BEGIN{
	$|++;     # Enable autoflush on STDOUT
	$, = " "; # Separator for print x,y,z
	$" = " "; # Separator for print "@array";
}

use FindBin;
use lib "$FindBin::Bin/../lib";
use SecretSanta;
use Test::More;
use DDP;

my @list;
=for rem
my @members = 'A'..'H';
my %members; @members{@members} = ();
my @pairs;
for (1..@members/3) {
	my ($one,$two) = keys %members;
	delete $members{$one};
	delete $members{$two};
	push @pairs, [ $one, $two ];
}
@list = sort { int(rand 3)-1 } @pairs, keys %members;
=cut
#
#@list = ('A','B','C','D');
#@list = (['A','B'],'C','D');
@list = (['A','B'],['C','D'],'E','F');
my $members = 0;

my %restrict;
for my $var (@list) {
	if (ref $var) {
		for my $l (@$var) {
			$restrict{$l}{$l}  = 1;
			for my $r (@$var) {
				next if $r eq $l;
				$restrict{$r}{$l} = 1;
				$restrict{$l}{$r}  = 1;
			}
			++$members;
		}
	}
	else {
		++$members;
		$restrict{$var}{$var}  = 1;
	}
}

my @res = SecretSanta::calculate(@list);
is 0+@res, $members, "Result list have correct count";
for (@res) {
	is ref $_, 'ARRAY', 'Result have correct format' or BAIL_OUT;
	is 0+@$_, 2, 'Result have correct format' or BAIL_OUT;
	my ($one,$two) = @$_;
	ok !$restrict{$one}{$two}, 'Pair not restricted'
		or diag "$one -> $two is prohibited";
	diag join " → ", @$_;
}

#exit;
my $N = 5000;
my %calcs;
for (1..$N) {
	my @res = SecretSanta::calculate(@list);
	for (@res) {
		my ($one,$two) = @$_;
		if ($restrict{$one}{$two}) {
			die "Pair $one -> $two is prohibited";
		}
		$calcs{$one}{$two}++;
	}
}
#p %calcs;
for my $one (sort keys %calcs) {
	for my $two (sort keys %{$calcs{$one}}) {
		diag sprintf "%s → %s: %0.2f%% (%d:%d)\n", $one, $two, $calcs{$one}{$two}*100/$N, $calcs{$one}{$two}, $N;
	}
}

done_testing();
