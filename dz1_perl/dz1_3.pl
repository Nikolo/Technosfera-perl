#!/usr/bin/perl
use strict;
use Data::Dumper;
use DDP;
my $file = "/home/eienkotonaru/dz1";
open(my $fh, '<', $file) or die "Файл не найден!";
my $matrix=[];
while(my $row = <$fh>){
	push($matrix, my ($first, $second, $third, $forth, $fifth, $sixth, $seventh, $eight, $ninth) = split(';', $row));
}
print Dumper($matrix);
p $matrix;
