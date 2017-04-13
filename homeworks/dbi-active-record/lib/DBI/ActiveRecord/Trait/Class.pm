package DBI::ActiveRecord::Trait::Class;
use Mouse::Role;

use Carp qw/confess/;

=encoding utf8

=head1 NAME

C<DBI::ActiveRecord::Trait::Class> - роль для мета-классов объектов ActiveRecord.

=head1 DESCRIPTION

Данный класс отвечает за описание объектов ActiveRecord - к какой БД подключаться, какая таблица связана с объектом и какие в ней поля, какое поле является первичным ключом и т.п.

=head1 ATTRIBUTES

=head2 db_class

Имя класса-адаптера для работы с БД. Обязательное.

=cut

has db_class => (
    is => 'rw',
    isa => 'Str',
);

=head2 table_name

Имя таблицы связанной с объектом. Обязательное.

=cut

has table_name => (
    is => 'rw',
    isa => 'Str',
);

=head2 primary_key

Имя поля, которое является первичным ключом. Обязательное.

=cut

=head2 auto_increment_field

Имя поля, значение для которого определяется самой БД. Значение данного поля будет игнорироваться при запросах вставки. Может быть не заданно. Если заданно, то всегда совпдает с C<primary_key>. 

=cut

has auto_increment_field => (
    is => 'rw',
    isa => 'Maybe[Str]',
);

=head2 fields

Список имен атрибутов объекта, которые являютс полями в БД.

=cut

has fields => (
    is => 'rw',
    isa => 'ArrayRef[Str]',
    default => sub { [] },
);

=head1 METHODS

=head2 after make_immutable

Выполняется после исполениния базового метода C<make_immutable> объекта.

Служит для валидации описания объекта. Вызывает исключения в случае, если валидация не пройдена. Например: не заданы БД, таблица или первичный ключ; первичный ключ определен более чем для одного поля; автоинкремент на поле, не являющимся первичным ключом и т.п.

Так же метод создает набор селекторов для выборки данных из БД. Для каждого поля С<$field>, которое определенно как индексное (параметр C<index> атрибута), создается метод вида:

    "select_by_".$field

Данный метод, просто вызывает метод C<select> объекта, передавая в него в качестве ключевого поля C<$field>.

Для неуникальных индексов, так же определяется лимит по умолчанию, который берется из параметра C<default_limit> атрибута. Для таких полей он является обязательным!

=cut

after make_immutable => sub {
    my ($self) = @_;

    confess "db class must be defined!" unless $self->db_class;
    confess "table must be defined!" unless $self->table_name;

    for my $field_name ( @{ $self->fields } ) {
        my $attr = $self->get_attribute($field_name);
        if($attr->index) {
            if($self->primary_key && $attr->index eq 'primary' && $field_name ne $self->primary_key) {
                confess "primary index must be used only once!";
            } elsif ($attr->index eq 'primary') {
                $self->primary_key($field_name);
            }
            if($attr->auto_increment) {
                unless($attr->index && $attr->index eq 'primary') {
                    confess "auto increment can be applied only on primary key!";
                } else {
                    $self->auto_increment_field($field_name);
                }
            }
            if($attr->index eq 'uniq' || $attr->index eq 'primary') {
                $self->add_method( "select_by_".$field_name => sub {
                    my ($class, $keys) = @_;
                    return $class->select($field_name, $keys);
                });
            } else {
                confess "default_limit must be defined for not uniq indexes!" unless defined $attr->default_limit;
                $self->add_method( "select_by_".$field_name => sub {
                    my ($class, $keys, $limit) = @_;
                    $limit ||= $attr->default_limit;
                    return $class->select($field_name, $keys, $limit);
                });
            }
        }
    }
    confess "primary index must be defined!" unless $self->primary_key;
    return;
};

no Mouse::Role;

1;
