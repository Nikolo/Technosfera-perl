package Local::PrettyTable;

use strict;
use warnings;

use Mouse;

has matrix => (
    is => 'ro',
    isa => 'ArrayRef[ArrayRef[Str]]',
    required => 1,
);

1;
