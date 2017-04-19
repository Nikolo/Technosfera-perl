use strict;
use warnings;

use Local::Schema;

my $schema = Local::Schema->new();

print $schema->resultset('Metric')->find(1)->measures->count();

1;
