use utf8;
package Local::Metric::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-04-25 18:32:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:s/EO+ywEs4t8eahw5ROkuQ

my $CONNECTION;
sub new {
    my ($class) = @_;

    my $config = Local::Metric::Config->default()->get('mysql');
    $CONNECTION //= $class->connect(
        'DBI:mysql:database=' . $config->{db},
        $config->{user}, $config->{password},
    );

    return $CONNECTION;
}

1;
