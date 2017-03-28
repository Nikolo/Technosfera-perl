use Table;

use 5.010;

my $table = Table->new(data => [[1, 2, 3]]);
say $table->data->[0]->[1];

Table->new();
