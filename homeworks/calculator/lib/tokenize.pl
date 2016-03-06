=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, состоящий из отдельных токенов.
Токен - это отдельная логическая часть выражения: число, скобка или арифметическая операция
В случае ошибки в выражении функция должна вызывать die с сообщением об ошибке

Знаки '-' и '+' в первой позиции, или после другой арифметической операции стоит воспринимать
как унарные и можно записывать как "U-" и "U+"

Стоит заметить, что после унарного оператора нельзя использовать бинарные операторы
Например последовательность 1 + - / 2 невалидна. Бинарный оператор / идёт после использования унарного "-"

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

sub tokenize {
	my @tokenedres;
	my $str = shift;
	my $it = 0;
	my $itres = 0;
	my $flag = 1;
	$str =~ s/\s*//g;
	my @tokened1 = split m{([\/\(\)\^\+\-\*])}, $str; # could be '' in case of operators standing together
	$str =~ s/\s*//g;
	while ($it <= $#tokened1) {
		if ($tokened1[$it] =~ /e$/) {
			$flag = 0;
			if (($tokened1[$it+1] =~ /\+|\-/) && ($tokened1[$it+2] =~ /\d+/)) {
				$tokenedres[$itres] = join('', $tokened1[$it], $tokened1[$it+1], $tokened1[$it+2]);
				$it += 3;
				$itres++;
				$flag = 1;
				next;
			}
			if ($tokened1[$it+1] =~/\d+/) {
				$tokenedres[$itres] = join('', $tokened1[$it], $tokened1[$it+1]);
				$it += 2;
				$itres++;
				$flag = 1;
				next;
			}
			return undef if !$flag;
		}
	$tokenedres[$itres] = $tokened1[$it];
	$it++;
	$itres++;
	}
	return @tokenedres if wantarray;
	1;
}

1;
