=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, содержащий обратную польскую нотацию
Один элемент массива - это число или арифметическая операция
В случае ошибки функция должна вызывать die с сообщением об ошибке

=cut

use 5.010;
use strict;
use warnings;
use diagnostics;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';
use FindBin;
require "$FindBin::Bin/../lib/tokenize.pl";
use feature 'say';

sub rpn {
	my $expr =" 3+ 4.7"; #shift;
	my $source = tokenize($expr);
	my @rpn=@$source;
	#print @$source;
	my @stack;
	for my $i ( @$source ) {
		given( $i ) {
			when ( /\d/ ) { push(@rpn,$i); }
			when ( /\+/ ) { push(@stack,$i); }
			#when ( /\-/ ) { if ($#rpn =~ /[\+\*\-]/) {;}
		}
	}
	
	push(@rpn,@stack);
	
	say join (' ', @rpn);	

	return \@rpn;
}
rpn();

1;
