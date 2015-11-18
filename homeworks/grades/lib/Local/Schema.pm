use utf8;
package Local::Schema;

use strict;
use warnings;

use base 'DBIx::Class::Schema';

our $VERSION = 1.00;

__PACKAGE__->load_namespaces;

1;

