package Local::PrettyTable;

use strict;
use warnings;

use Mouse;

has data => (
    is => 'ro',
    isa => 'ArrayRef[ArrayRef[Str]]',
    required => 1,
);

1;
