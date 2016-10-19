package Local::TCP::Calc::Server::Worker;

use strict;
use warnings;
use Mouse;

has cur_task_id => (is => 'ro', isa => 'Int', required => 1);
has forks       => (is => 'rw', isa => 'HashRef', default => sub {return {}});
has calc_ref    => (is => 'ro', isa => 'CodeRef', required => 1);
has max_forks   => (is => 'ro', isa => 'Int', required => 1);

sub write_err {
	my $self = shift;
	my $error = shift;
	...
	# Записываем ошибку возникшую при выполнении задания
}

sub write_res {
	my $self = shift;
	my $res = shift;
	...
	# Записываем результат выполнения задания
}

sub child_fork {
	my $self = shift;
	...
	# Обработка сигнала CHLD, не забываем проверить статус завершения процесс и при надобности убить оставшихся
}

sub start {
	my $self = shift;
	my $task = shift;
	...
	# Начинаем выполнение задания. Форкаемся на нужное кол-во форков для обработки массива примеров
	# Вызов блокирующий, ждём  пока не завершатся все форки
	# В форках записываем результат в файл, не забываем про локи, чтобы форки друг другу не портили результат
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;
