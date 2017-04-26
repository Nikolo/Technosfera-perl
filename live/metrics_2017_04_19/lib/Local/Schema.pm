use utf8;
package Local::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-04-19 18:58:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:abnN8YEwG0BAFw2oY1rqCg

our $_SCHEMA;

sub new {
    my ($class) = @_;

    unless (defined $_SCHEMA) {
        $_SCHEMA = $class->connect(
            'DBI:mysql:database=metrics;host=localhost',
            'metrics', 'metrics', {}
        );
    }

    return $_SCHEMA;
}

1;
