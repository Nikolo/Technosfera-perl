package Local::Schema;

use parent 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces();

our $_SCHEMA;

sub new {
    my ($class) = @_;

    unless (defined $_SCHEMA) {
        $_SCHEMA = $class->connect('DBI:mysql:database=metrics;host=localhost', 'metrics', 'metrics', {}); 
    }

    return $_SCHEMA;
}

1;
