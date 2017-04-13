package DBI::ActiveRecord::DB::SQLite;
use Mouse;
extends 'DBI::ActiveRecord::DB';

use Carp qw/confess/;

=encoding utf8

=head1 NAME

C<DBI::ActiveRecord::DB::SQLite> - базовый класс-адаптер для работы с БД SQLite. 

=head1 DESCRIPTION

Данный класс, реализует специфические методы, для работы с БД SQLite.

Если вам требуется использовать SQLite для своих ActiveRecord объектов, то следует отнаследоваться от данного класса, и определить в наследнике метод C<_build_connection_params>.

=head1 PRIVATE METHODS

=head2 _select($table, $fields, $key_field, $keys, $is_uniq, $limit)

Метод для непосредственной выборки данных из БД.

Выбирается список полей C<$fields> из таблицы C<$table> по ключевому полю C<$key_field>, которое принимает значения C<$keys>. Если ключевое поле уникальное, должен быть передан флаг C<$is_uniq>. Иначе требуется передать лимит выборки C<$limit>.

=cut

sub _select {
    my ($self, $table, $fields, $key_field, $keys, $is_uniq, $limit) = @_;

    my $dbh = $self->connection;

    my $where_str = "";
    my $limit_str = "";
    my @bind  = @$keys;
    if(@bind == 1) {
        $where_str = "$table.$key_field = ?";
    } else {
        $where_str = "$table.$key_field IN (".( join ", ", map { "?" } @bind ).")";
        unless($is_uniq) {
            $limit_str = "LIMIT ?";
            push @bind, $limit;
        }
    }

    my $fields_str = join ", ", map { $table.".".$_ } @$fields;

    my $result = [];
    my $sth = $dbh->prepare("SELECT $fields_str FROM $table WHERE $where_str $limit_str");
    if($sth->execute(@bind)) {
        while(my $data = $sth->fetchrow_hashref) {
            push @$result, $data;
        }
    } else {
        confess "can't execute select request!";
    }
    return $result;
}

=head2 _insert($table, $autoinc_field, $fields, $values)

Метод для непосредственной вставки данных в БД.

Данные для полей C<$fields> со значениями C<$values> вставляются в таблицу C<$table>. Если первичный ключ автоинкрементальный, то его имя должно быть передано в параметре C<$autoinc_field>.

=cut

sub _insert {
    my ($self, $table, $autoinc_field, $fields, $values) = @_;

    my $dbh = $self->connection;

    my $fields_str = join ", ", @$fields;
    my $placeholders = join ", ", map { "?" } @$fields; 

    $dbh->begin_work;
    my $last_insert_id;
    if($dbh->do("INSERT INTO $table ($fields_str) VALUES ($placeholders)", {}, @$values)) {
        $last_insert_id = $autoinc_field ? $dbh->last_insert_id("", "", $table, $autoinc_field) : 0;
        $dbh->commit; 
    } else {
        $dbh->rollback;
        confess "can't do insert request!";
    }
    return $last_insert_id;
}

=head2 _update($table, $key_field, $key_value, $fields, $values)

Метод для непосредственного обновления данных в БД.

Данные для полей C<$fields> обновляются значениями C<$values> в таблице C<$table>. Обновляется данные по первичному ключу C<$key_field> со значением C<$key_value>.

=cut

=head2 _delete($table, $key_field, $key_value)

Метод для непосредственного удаления данных из БД.

Данные удаляются из таблицы C<$table> по первичному ключ C<$key_field> со значением C<$key_value>.

=cut

sub _delete {
    my ($self, $table, $key_field, $key_value) = @_;

    my $dbh = $self->connection;

    if($dbh->do("DELETE FROM $table WHERE $key_field = ?", {}, $key_value)) {
        return 1;
    } else {
        confess "can't do delete request!";
    }
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;

