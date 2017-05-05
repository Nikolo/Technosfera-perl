use strict;
use warnings;
use DDP;
use Data::Dumper;


if (! open CONFIG, "/media/DATA/фильмы/123.txt"){
die "Cannot create logfile: $!";}
my @ar1=();
my @ar2=();
while (<CONFIG>){
@ar1=split(";");
push(@ar2,@ar1);}
p @ar2;
print Dumper(@ar2);


