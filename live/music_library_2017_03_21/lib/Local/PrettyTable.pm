package Local::PrettyTable;

use strict;
use warnings;

use Mouse;

has matrix => (
    is => 'ro',
    isa => 'ArrayRef[ArrayRef[Str]]',
    required => 1,
);

sub cols_width {
    my ($self) = @_;
    
    my @result;
    foreach my $row (@{$self->matrix}) {
        foreach my $col_n (0 .. $#{$row}) {
            my $length = length($row->[$col_n]);
            $result[$col_n] = $length if $length > ($result[$col_n] // 0);
        }
    }

    return \@result;
}

sub width {
    my ($self) = @_;

    foreach my $row (@{$self->matrix}) {
        
    }

    return;
}

sub header {
    my ($self) = @_;

    return;
}

sub to_string {
    my ($self) = @_;

    return;
}

1;
