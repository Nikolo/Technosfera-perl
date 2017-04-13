package DBI::ActiveRecord::Object;
use Mouse;

use Carp qw/confess/;

=encoding utf8

=head1 NAME

C<DBI::ActiveRecord::Object> - базовый класс для всех объектов ActiveRecord.

=head1 DESCRIPTION

Все объекты использующие C<DBI::ActiveRecord> автоматически наследуются от данного класса. Класс определяет базовый набор методов для работы с БД. Каждый такой метод, получает экземпляр класса-адаптера для доступа к БД через поле C<db_class> мета-класса объекта, и вызывает у него соответсвующий метод для работы с БД.

Всего доступны четыре метода:

=over 4

=item 1. select

=item 2. insert

=item 3. update

=item 4. delete

=back

=head1 METHODS

=head2 select($field, $keys, $limit)

Метод класса для выборки данных из БД по полю С<$field>, которое может принимать значения/значение C<$keys>. Параметр C<$limit> определяет лимит выборки, при запросах в БД по неуникальному ключу.

=cut

sub select {
    my ($class, $field, $keys, $limit) = @_;
    return $class->meta->db_class->instance->select($class, $field, $keys, $limit);
}

=head2 insert()

Метод объекта для встаки данных в БД. Все данные для вставки берутся из атрибутов-полей объекта.

=cut

sub insert {
    my ($self) = @_;
    return $self->meta->db_class->instance->insert($self);
}

=head2 update()

Метод объекта для обновления данных в БД. Все данные для обновления берутся из атрибутов-полей объекта.

=cut

=head2 delete()

Метод объекта для удаления данного объекта из БД.

=cut

sub delete {
    my ($self) = @_;
    return $self->meta->db_class->instance->delete($self);
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;
