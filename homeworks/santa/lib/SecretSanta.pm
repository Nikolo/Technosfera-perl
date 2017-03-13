package SecretSanta;

use 5.010;
use strict;
use warnings;
use DDP;

sub calculate{
	if (!(ref $_[0]) && scalar @_<=2){
		say 'no solutions!';
		return;
	}
	my @names = sort {int(rand(3)) -1}@_;
	my @persons = randDistributer(@names);

	while(grep {$_->{santa} == -1}@persons){
			@persons = randDistributer(@names);
		}
	my @pairsSortById = sort {$a->{id} <=> $b ->{id}}@persons;
	my @pairs = map {[$_->{name}, @pairsSortById[$_->{target}]->{name}]}@persons;

	p @persons;
	p @pairs;
	return @pairs;
}


sub buildHashesArray{

	my @persons;
	my $i = 0;
	for (@_){
		
		if(ref $_ eq ''){
			push @persons , {
				id => $i++,
				name => $_, 
				target => -1,
				santa => -1,
				pair => -1
			};
		} else {
			
			push @persons , {
				id => $i++,
				name => $_->[0], 
				target => -1,
				santa => -1,
				pair => $i
			};

			push @persons , {
				id => $i++,
				name => $_->[1], 
				target => -1,
				santa => -1,
				pair => $i-2
			};
		}

	}
	return @persons;
	
}

sub givePresent{
	#$_[0] -- santa, $_[1] -- target
	if ($_[0]->{id} != $_[1]->{id} && 
		$_[0]->{id} != $_[1]->{target} &&
		$_[0]->{id} != $_[1]->{pair} &&
		$_[1]->{santa}==-1){
		
		
		$_[0]->{'target'} = $_[1]->{'id'};
		$_[1]->{'santa'} = $_[0] ->{'id'};
		return 1;

	} else{
		return 0;
	}
		 
	
}

sub generateRandomIdList{
	my @persons = @_;
	
	return sort {int(rand(3)) -1} (map {$_-> {'id'}}@persons);
}

sub randDistributer{

	my @persons = sort {int(rand(3)) -1}buildHashesArray(@_);
	

	for my $person (@persons){
		
		for my $randId ( generateRandomIdList(@persons)){
			print $randId;
			if(givePresent($person, grep {$_->{id}==$randId}@persons)){
				last;
			}
		}
		print "  $person->{name}\n";
	}

	return @persons;
	


}

1;
