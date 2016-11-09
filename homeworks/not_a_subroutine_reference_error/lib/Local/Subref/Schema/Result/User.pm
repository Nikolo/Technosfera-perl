package Local::Subref::Schema::Result::User;
use base qw(DBIx::Class);

__PACKAGE__->load_components('Core');
__PACKAGE__->table('user');
__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_auto_increment => 1,
    },
    name => {
        data_type => 'varchar',
        size      => '100',
    },
    comment => {
        data_type     => 'varchar',
        size          => '100',
        is_nullable   => 1,
    },
    superuser => {
        data_type => 'bool',
    },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many(
    accounts => 'Local::Subref::Schema::Result::Account',
    'user_id'
);

1;
