package DBI::ActiveRecord;
use Mouse;
use Mouse::Exporter;
use Mouse::Util::MetaRole;

use Carp qw/confess/;

=encoding utf8

=head1 NAME

C<DBI::ActiveRecord> - основной класс, через который происходит взаимодействие с внешним миром. Именно он должен подключаться в ваших пакетах, что бы сделать их объектами ActiveRecord.

=head1 DESCRIPTION
 
При подключении модуля C<DBI::ActiveRecord>, подключающий пакет, автоматически становится наследником класса C<DBI::ActiveRecord::Object>, а так же подключает к вашему классу трейт C<DBI::ActiveRecord::Trait::Class>.

Класс предоставляет три sugar-функции, для описания модели данных:

=over 4

=item 1. db - служит для опеределния БД, к которой нужно осуществлять подключение.

=item 2. table - имя таблицы в БД.

=item 3. has_field - оперделяет описание поля таблицы (колонки).

=back

=cut

Mouse::Exporter->setup_import_methods(
    as_is => [qw/db table/],
    also => 'Mouse',
); 

=head1 FUNCSTIONS AND METHODS

=head2 init_meta($class, %args)

Данный метод - Mouse "надстройка" над методом C<import>. Он вызывается при подключении C<Mouse> модуля через C<use>.

Чаще всего это используется для подмены базового класса ваших C<Mouse>-объектов, а так же добавления ролей к мета-классу.

=cut

sub init_meta {
    my ($class, %args) = @_;

    Mouse->init_meta(base_class => 'DBI::ActiveRecord::Object', %args);
    Mouse::Util::MetaRole::apply_metaroles(
        for => $args{for_class},
        class_metaroles => {
            class => ['DBI::ActiveRecord::Trait::Class'],
        },
    );
    return $args{for_class}->meta();
}

=head2 db($db_class)

Sugar-функция для определения класса, который будет отвечать, за подключение к БД.
В качестве параметра примимает строку с именем класса БД, которое сохраняется в мета-атрибуте C<db_class> и может быть полученно (изменено) из вашего объекта, например так:

    $self->meta->db_class();
    $self->meta->db_class($new_db_class);

Мета-атрибут C<db_class> был добавлен подключением трейта C<DBI::ActiveRecord::Trait::Class>.

=cut

sub db {
    my ($db_class) = @_;
    my $meta = caller->meta;
    $meta->db_class($db_class);
}

=head2 table($table_name)

Sugar-функция для определения имени таблицы, связанной с объектом.
В качестве параметра примимает строку с именем таблицы, которое сохраняется в мета-атрибуте C<table_name> и может быть полученно (изменено) из вашего объекта, например так:

    $self->meta->table_name();
    $self->meta->table_name($new_table_name);

Мета-атрибут C<db_class> был добавлен подключением трейта C<DBI::ActiveRecord::Trait::Class>.

=cut

sub table {
    my ($table_name) = @_;
    my $meta = caller->meta;
    $meta->table_name($table_name);
}

=head2 has_field($field, %params)

Sugar-функция для создания атрибутов, связанных с колонками таблицы C<table>. Функция принимает, в качестве первого параметра, имя атрибута, которое должно совпадать с именем колонки в таблице.

Далее передается хеш-параметров, описывающих атрибут. Функция создает C<Mouse>-атрибут с указанным именем и параметрами в вашем объекте.

В качестве параметров можно передать любые параметры, которые можно передать в C<Mouse>-функцию C<has>, за исключением параметра C<is> - его значение игнорируется и атрибут создается всегда доступный для чтения и записи.

Кроме того, в качестве параметров можно указать любые дополнительные параметры, определенные трейтом C<DBI::ActiveRecord::Trait::Attribute::Field>.

Все созданные C<has_field> атрибуты складывается в мета-атрибут C<fields>, определяемый трейтом C<DBI::ActiveRecord::Trait::Class>.

=cut

1;
