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

has _cols_width => (
    is => 'ro',
    isa => 'ArrayRef[Int]',
    required => 1,
    lazy => 1,
    builder => '_build__cols_width',
);

has _width => (
    is => 'ro',
    isa => 'Int',
    required => 1,
    lazy => 1,
    builder => '_build__width',
);


sub _build__cols_width {
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

sub _build__width {
    my ($self) = @_;

    my $margins = 2 * @{$self->_cols_width}; 
    my $borders = @{$self->_cols_width} + 1;

    return sum($margins, $borders, @{$self->_cols_width});
}

sub _header {
    my ($self) = @_;

    return '/' . ('-' x ($self->_width - 2)) . '\\';
}

sub to_string {
    my ($self) = @_;

    return;
}

1;
