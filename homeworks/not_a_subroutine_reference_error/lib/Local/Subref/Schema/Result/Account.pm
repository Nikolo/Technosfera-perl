package Local::Subref::Schema::Result::Account;
use base qw(DBIx::Class);

__PACKAGE__->load_components('Core');
__PACKAGE__->table('account');
__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_auto_increment => 1,
    },
    sum => {
        data_type => 'integer',
    },
    user_id => {
        data_type => 'integer',
    },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(
    user => 'Local::Subref::Schema::Result::User',
    'user_id'
);

1;
