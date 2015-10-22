package Local::Iterator::Concater;

use strict;
use warnings;

=encoding utf8

=head1 NAME

Local::Iterator::Concater - concater of other iterators

=head1 SYNOPSIS

    my $iterator = Local::Iterator::Concater->new(
        iterators => [
            $another_iterator1,
            $another_iterator2,
        ],
    );

=cut

1;
