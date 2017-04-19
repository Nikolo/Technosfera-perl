use strict;
use warnings;

use Local::Schema;

my $schema = Local::Schema->new();

use Data::Dumper; print Dumper [
    $schema->storage->dbh->selectrow_arrayref('SELECT 1')
];

1;
