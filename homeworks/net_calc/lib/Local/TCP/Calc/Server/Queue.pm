package Local::TCP::Calc::Server::Queue;

use strict;
use warnings;

use Mouse;
use Local::TCP::Calc;

has f_handle       => (is => 'rw', isa => 'FileHandle');
has queue_filename => (is => 'ro', isa => 'Str', default => '/tmp/local_queue.log');
has max_task       => (is => 'rw', isa => 'Int', default => 0);

sub init {
	my $self = shift;
	...
	# Подготавливаем очередь к первому использованию если это необходимо
}

sub open {
	my $self = shift;
	my $open_type = shift;
	...
	# Открваем файл с очередью, не забываем про локи, возвращаем содержимое (перловая структура)
}

sub close {
	my $self = shift;
	my $struct = shift;
	...
	# Перезаписываем файл с данными очереди (если требуется), снимаем лок, закрываем файл.
}

sub to_done {
	my $self = shift;
	my $task_id = shift;
	my $file_name = shift;
	...
	# Переводим задание в статус DONE, сохраняем имя файла с резуьтатом работы
}

sub get_status {
	my $self = shift;
	my $id = shift;
	...
	# Возвращаем статус задания по id, и в случае DONE или ERROR имя файла с результатом
}

sub delete {
	my $self = shift;
	my $id = shift;
	my $status = shift;
	...
	# Удаляем задание из очереди в соответствующем статусе
}

sub get {
	my $self = shift;
	...
	# Возвращаем задание, которое необходимо выполнить (id, tasks)
}

sub add {
	my $self = shift;
	my $new_work = shift;
	...
	# Добавляем новое задание с проверкой, что очередь не переполнилась
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;
