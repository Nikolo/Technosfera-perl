use utf8;
package Local::Experiment::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-04-24 18:41:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0md5Yj9MQZSiCBJZZfcgRw

sub new {
    my ($class) = @_;

    return $class->connect(
        'DBI:mysql:database=experiment;host=localhost',
        'experiment', 'experiment'
    );
}

1;
