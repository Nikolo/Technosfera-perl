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

sub _get_tokens {
    my ($self) = @_;

    my @result;

    while ($self->string =~ m{
        \G ( \d+    )|
        \G ( [+*/-] )|
        \G ( \s+    )|
        \G ( .+     )
    }xg) {
        if (length($1)) {
            push(@result, $1);
        }
        elsif (length($2)) {
            push(@result, $2);
        }
        elsif (length($3)) {
            # spaces
        }
        elsif (length($4)) {
            die "Don't know how to parse $4";
        }
        else {
            die q{Shouldn't be here};
        }
    }

    return \@result;
}

1;
