package VFS;
use utf8;
use strict;
use warnings;
use 5.010;
use File::Basename;
use File::Spec::Functions qw{catdir};
use JSON::XS;
no warnings 'experimental::smartmatch';

sub mode2s {
	# Тут был полезный код для распаковки численного представления прав доступа
	# но какой-то злодей всё удалил.
}

sub parse {
	my $buf = shift;
	
	# Тут было готовое решение задачи, но выше упомянутый злодей добрался и
	# сюда. Чтобы тесты заработали, вам предстоит написать всё заново.
}

1;
