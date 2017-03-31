package Local::Expression;

use strict;
use warnings;
use utf8;

use Mouse;

has string => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

1;
