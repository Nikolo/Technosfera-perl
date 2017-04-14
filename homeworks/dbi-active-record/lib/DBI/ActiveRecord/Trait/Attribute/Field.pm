package DBI::ActiveRecord::Trait::Attribute::Field;
use Mouse::Role;
use Mouse::Util::TypeConstraints;

=encoding utf8

=head1 NAME

C<DBI::ActiveRecord::Trait::Attribute::Field> - роль-трейт для описания полей таблицы БД.

=head1 DESCRIPTION

Данный класс расширяет функционал базовых атрибутов C<Mouse>, с целью описания в них полей таблиц БД.

=head1 SUBTYPES

=head2 PositiveInt

Тип ограничивающий значения атрибута целыми положительными числами.

=cut

=head2 IndexEmum

Тип-перечисление ограничивающий значения атрибута значениями: C<primary>, C<uniq>, C<common>.

=cut

=head1 ATTRIBUTES

=head2 index

При наличии оперделяет атрибут объекта как индекс. Может принимать значения C<IndexEnum>.

=cut

has index => (
    is => 'rw',
    isa => 'IndexEnum'
);

=head2 auto_increment

При наличии оперделяет атрибут объекта как автоинкрементальный. Может принимать значения 0 или 1.

=cut

has auto_increment => (
    is => 'rw',
    isa => 'Bool'
);

=head2 default_limit

Для атрибутов объекта с C<index> равным C<common>, определяет лимит выборки по умолчнию. Примимает значения C<PositiveInt>.

=cut

has default_limit => (
    is => 'rw',
    isa => 'PositiveInt',
);

=head2 serializer

Определяет функцию, которая преобразует значение атрибута объекта перед записью в БД.

=cut

has serializer => (
    is => 'rw',
    isa => 'CodeRef',
);

=head2 deserializer

Определяет функцию, которая преобразует значение из БД перед записью в атрибут объекта.

=cut

has deserializer => (
    is => 'rw',
    isa => 'CodeRef',
);

no Mouse::Role;

1;
