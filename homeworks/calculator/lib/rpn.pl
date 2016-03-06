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
require "$FindBin::Bin/../lib/evaluate.pl";
sub rpn {
	my %priority = ( 
		'U-' =>  4, 'U+' => 4,
		'^' => 4, 
		'*' => 2, '/' => 2, 
		'+' => 1, '-' => 1, 
		'(' => 0, ')' => 0);
	my $str = shift;
	my $char;	
	my @tokened = tokenize($str);
	my $before = '';
	my $number;
	my @RPN;
	my @stack;
	my $flag = 0;
	my $unary = 0;
	for $char (@tokened) {
		$flag = 0;
		if ($char =~ /^\s*$/) {
			if ($before eq ')' || $before eq '' ) {
				$flag = 1;
			} 
			next;
		}		#skip if tabs/spaces etc.
		given ($char) {
			when (/^\-?\d+$|^\-?\d*\.\d+$|^\-?\d+e\d+$|^\-?\d+e[\+\-]\d+$|^\-?\d*\.\d+e\d+$|^\-?\d*\.\d+e[\+\-]\d+$/) {
				$number = 0+$char;
				push (@RPN, $number);
				next;
			}
			when (/\(/) {
				push (@stack, $char);
				next;
			}
			when (/[\-\+]/) {
				if ($char =~ /-/ && $before =~ /^\s*$/) { #$before is empty <=> 2 operators stood together
					$char = 'U-';
					$unary = 1;
				}
				if ($char eq '+' && $before =~/^\s*$/) {
					$char = 'U+';
					$unary = 1;
				}
				if ($unary == 0) {
					while (@stack && $priority{$char} <= $priority{$stack[$#stack]}) {
						push(@RPN, $stack[$#stack]);
						pop(@stack);
					} 
					
				} 
				else {
					
					while (@stack && $priority{$char} < $priority{$stack[$#stack]}) {
						push(@RPN, $stack[$#stack]);
						pop(@stack);
					} 
				
				}
				$unary = 0;
				push (@stack, $char);
				next;
			}
			when (/[\*\/]/) {
				while ( @stack && ($priority{$char} <= $priority{$stack[$#stack]}) ) {
						push(@RPN, $stack[$#stack]);
						pop(@stack);
					} 
					
				push (@stack, $char);
				next;
			}
			when ('^') {
				while (@stack && $priority{$char} < $priority{$stack[$#stack]}) {
						push(@RPN, $stack[$#stack]);
						pop(@stack);
					} 
					
				
				push (@stack, $char);
				next;
			}
			when ('(') {
				push (@stack, '(');
				next;
			}
			when (')') {
				while (@stack && $stack[$#stack] ne '(') {
					if ($#stack == 0) {print "Error: check ()"; return die;}
					push(@RPN, $stack[$#stack]);
					pop(@stack);
				}
				pop(@stack);
				next;
			}
			default {print "Error:couldn't evaluate"; return die;}
		}
	} continue {$before = $char unless $flag;}
	while (@stack) {
		push(@RPN, $stack[$#stack]);
		pop(@stack);
	}
	return die if (evaluate(\@RPN) eq 'Err');
	return \@RPN;
1;
}

1;
