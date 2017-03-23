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

has _left_margin => (
    is => 'ro',
    isa => 'Int',
    required => 1,
    default => 1,
);

has _right_margin => (
    is => 'ro',
    isa => 'Int',
    required => 1,
    default => 1,
);

has _total_margin => (
    is => 'ro',
    isa => 'Int',
    required => 1,
    lazy => 1,
    default => sub {
        my ($self) = @_;
        return $self->_left_margin + $self->_right_margin;
    },
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

    my $margins = $self->_total_margin * @{$self->_cols_width}; 
    my $borders = @{$self->_cols_width} + 1;

    return sum($margins, $borders, @{$self->_cols_width});
}

sub _header {
    my ($self) = @_;

    my $borders = 2;

    return '/' . ('-' x ($self->_width - $borders)) . '\\' . "\n";
}

sub _footer {
    my ($self) = @_;

    my $borders = 2;

    return '\\' . ('-' x ($self->_width - $borders)) . '/' . "\n";
}

sub _separator {
    my ($self) = @_;

    my @cols = map {'-' x ($_ + $self->_total_margin)} @{$self->_cols_width};

    return '|' . join('+', @cols) . '|' . "\n";
}

sub _row {
    my ($self, $row_n) = @_;

    my $row = $self->matrix->[$row_n];
    my @cells;
    foreach my $col_n (0 .. $#{$row}) {
        my $width = $self->_cols_width->[$col_n];
        my $cell = (
            (' ' x $self->_left_margin) .
            sprintf("%${width}s", $row->[$col_n]) .
            (' ' x $self->_right_margin)
        );
        push(@cells, $cell);
    }

    return '|' . join('|', @cells) . '|' . "\n";
}

sub to_string {
    my ($self) = @_;

    return join('', (
        $self->_header,
        join(
            $self->_separator,
            map {$self->_row($_)} (0 .. $#{$self->matrix})
        ),
        $self->_footer,
    ));
}

1;
