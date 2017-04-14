package DBI::ActiveRecord::DB;
use Mouse;

use DBI;
use Carp qw/confess/;

=encoding utf8

=head1 NAME

C<DBI::ActiveRecord::DB> - базовый абстрактный класс-адаптер для работы с БД.

=head1 DESCRIPTION

Данный класс используется непосредственно для работы с БД. Его абстрактность обусловленна тем, что различные СУБД требуют различных подходов, по работе с ними. Вся специфическая работа, непосредственно с СУБД должна определяться в классах наследниках от C<DBI::ActiveRecord::DB> (например, см. C<DBI::ActiveRecord::DB::SQLite>).

Данный класс реализует паттерн синглтон - объект создается один раз, при первом обращении к классу, и используется при всех последующих обращениях. Доступ к этому объекту осуществляется через метод класса C<instance>.

=head1 ATTRIBUTES

=head2 connection_params

Атрибут, в котором задаются параметры подключения к БД, в виде ссылки на массив. Например:

    $instance->connection_params([ 'dbi:SQLite:dbname=/tmp/somebase.db', '', '', {} ]);

Значение атрибута, может быть автоматически сгененрированно, путем определения в наследниках метода C<_build_connection_params>, который должен возвращать ссылка на массив с параметрами.

=cut

has connection_params => (
    is => 'rw',
    isa => 'ArrayRef',
    lazy => 1,
    builder => '_build_connection_params',
);

sub _build_connection_params { confess "Method must be subclassed" }

=head2

Атрибут, в котором хранится подключение в БД (некий DBD handler).

=cut

has connection => (
    is => 'rw',
    isa => 'Object',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        my $params = $self->connection_params;
        return DBI->connect(@$params);
    },
);

my $instance;
sub BUILD { $instance = $_[0] }

=head1 METHODS

=head2 instance

Метод класса для получения объекта. Сделуюет использовать непосредственно вместо метода C<new>.

=cut

sub instance {
    my ($class) = @_;
    $instance ||= $class->new();
    return $instance;
}

=head2 select($klass, $field, $keys, $limit)

Метод для выбоки из БД, вызывающийся из наследников класса C<DBI::ActiveRecord::Object>. C<$klass> - класс ActiveRecord объекта, который будет использован для конструирования.

Значения ключевого поля перед передачей в SQL запрос, должны сериализовываться фунцией C<serialize>, если она оперделена для данного атрибута.

Для ключевого поля должен быть определен атрибут C<index>, в противном случае будет вызвано исключение!

Значения полей полученных из БД, должны быть десериализованны фунциями C<deserialize>, если таковые определены для этих атрибутов.

=cut

sub select {
    my ($self, $klass, $field, $keys, $limit) = @_;

    my $wantarray = ref $keys ? 1 : 0;
    $keys = [ $keys ] unless ref $keys;

    confess "can't do select on zero keys list!" unless @$keys;
    confess "limit can be applied only for one-key select request!" if $limit && $limit > 1 && @$keys > 1;

    my $key_attr = $klass->meta->get_attribute($field);
    confess "field '$field' isn't index field!" unless $key_attr->index;

    my $is_uniq = $key_attr->index ne 'common';
    my @select_keys = @$keys;
    if($key_attr->serializer) {
        $_ = $key_attr->serializer->($_) for @select_keys;    
    }

    my $result = [];
    my $data = $self->_select($klass->meta->table_name, $klass->meta->fields, $field, \@select_keys, $is_uniq, $limit);
    for(@$data) {
        for my $k (keys %$_) {
            my $attr = $klass->meta->get_attribute($k);
            $_->{$k} = $attr->deserializer->($_->{$k}) if $attr->deserializer;
        }
        push @$result, $klass->new($_);
    }
    return $wantarray ? $result : $result->[0];
}

=head2 insert($obj)

Метод для вcтавки C<$obj> в БД, вызывающийся из наследников класса C<DBI::ActiveRecord::Object>.

Значения полей перед передачей в SQL запрос, должны сериализовываться фунциями C<serialize>, если они оперделены для данных атрибутов.

Если первичный ключ автоинкрементальный и для него определена функция C<deserialize>, то его значение полученое из БД должно десериализовываться. 

=cut

sub insert {
    my ($self, $obj) = @_;

    my $fields = $obj->meta->fields;
    my @ok_fields = grep { not $obj->meta->get_attribute($_)->auto_increment } @$fields;
    my @bind = ();
    for(@ok_fields) {
        my $attr = $obj->meta->get_attribute($_);
        push @bind, ( $attr->serializer ? $attr->serializer->($obj->$_) : $obj->$_ );
    }

    my $autoinc_field = $obj->meta->auto_increment_field;
    my $last_insert_id = $self->_insert($obj->meta->table_name, $autoinc_field, \@ok_fields, \@bind);
    if($autoinc_field) {
        if(defined $last_insert_id) {
            my $attr = $obj->meta->get_attribute($autoinc_field);
            $last_insert_id = $attr->deserializer->($last_insert_id) if $attr->deserializer;
            $obj->$autoinc_field($last_insert_id);
        } else {
            confess "can't set auto increment field value!";
        }
    }
    return 1;
}

=head2 update($obj)

Метод для обновления C<$obj> в БД, вызывающийся из наследников класса C<DBI::ActiveRecord::Object>.

Значения первичного ключа и остальных полей перед передачей в SQL запрос, должны сериализовываться фунциями C<serialize>, если они оперделены для данных атрибутов.

=cut

=head2 delete($obj)

Метод для удаления C<$obj> из БД, вызывающийся из наследников класса C<DBI::ActiveRecord::Object>.

Значениe ключевого поля перед передачей в SQL запрос, должно сериализовываться фунцией C<serialize>, если она оперделена для данного атрибута.

=cut

sub delete {
    my ($self, $obj) = @_;

    my $key_field = $obj->meta->primary_key;
    my $key_attr  = $obj->meta->get_attribute($key_field);
    my $key_value = $obj->$key_field;
    $key_value    = $key_attr->serializer->($key_value) if $key_attr->serializer;

    return $self->_delete($obj->meta->table_name, $key_field, $key_value);
}

sub _select { confess "Method must be subclassed" }
sub _insert { confess "Method must be subclassed" }
sub _update { confess "Method must be subclassed" }
sub _delete { confess "Method must be subclassed" }


no Mouse;
__PACKAGE__->meta->make_immutable();

1;

