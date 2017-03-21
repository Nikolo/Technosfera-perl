package Local::PrettyTable;

use strict;
use warnings;

use Mouse;

use List::Util qw(sum);

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

    my $margins = 2 * @{$self->cols_width}; 
    my $borders = @{$self->cols_width} + 1;

    return sum($margins, $borders, @{$self->cols_width});
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
