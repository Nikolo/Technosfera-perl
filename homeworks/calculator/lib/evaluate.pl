=head1 DESCRIPTION

Эта функция должна принять на вход ссылку на массив, который представляет из себя обратную польскую нотацию,
а на выходе вернуть вычисленное выражение

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

sub evaluate {
	my $rpnref = shift;
	my @rpn = @$rpnref;
	my $el;
	my @stack;
	for $el (@rpn) {
		given ($el) {
			when ('U-') {
				if (@stack && $stack[$#stack] =~ /\-?\d+|\-?\d*.\d+/) {$stack[$#stack] = 0 - $stack[$#stack];}
				else {return 'Err';} 
				next;
			}
			when ('U+') { next;}
			when ('^') {
				if (&& $stack[$#stack] =~ /\-?\d+|\-?\d*.\d+/ && $stack[$#stack-1] =~ /\-?\d+|\-?\d*.\d+/) {
					splice (@stack, $#stack-1, 2, $stack[$#stack-1]**$stack[$#stack]);
				} else {return 'Err';}
				next;
			}
			when ('*') {
				if ($#stack >= 1 && $stack[$#stack] =~ /\-?\d+|\d*.\d+/ && $stack[$#stack-1] =~ /\-?\d+|\d*.\d+/) {
					splice (@stack, $#stack-1, 2, $stack[$#stack-1]*$stack[$#stack]);
				} else {return 'Err';}
				next;
			}
			when ('/') {
				if ($#stack >= 1 && $stack[$#stack] =~ /\-?\d+|\-?\d*.\d+/ && $stack[$#stack-1] =~ /\-?\d+|\-?\d*.\d+/) {
					if ($stack[$#stack] == 0) {return 'NaN';} 
					splice (@stack, $#stack-1, 2, $stack[$#stack-1]/$stack[$#stack]);
				} else {return 'Err';}
				next;
			}
			when ('+') {
				if ($#stack >= 1 && $stack[$#stack] =~ /\-?\d+|\-?\d*.\d+/ && $stack[$#stack-1] =~ /\-?\d+|\-?\d*.\d+/) {
					splice (@stack, $#stack-1, 2, $stack[$#stack-1]+$stack[$#stack]);
				} else {return 'Err';}
				next;
			}
			when ('-') {
				if ($#stack >= 1 && $stack[$#stack] =~ /\-?\d+|\d*.\d+/ && $stack[$#stack-1] =~ /\-?\d+|\-?\d*.\d+/) {
					splice (@stack, $#stack-1, 2, $stack[$#stack-1]-$stack[$#stack]);
				} else {return 'Err';}
				next;
			}
			when (/\-?\d+|\-?\d*.\d+/) {push(@stack, $el);}
			default {return 'Err';}
		}
	}
	if ($stack[$#stack]=~ /\-?\d+|\-?\d*.\d+/) {return $stack[$#stack];}
	return 'Err';
1;
}

1;
