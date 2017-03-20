package Local::PrettyTable;

use strict;
use warnings;

use Mouse;

use List::Util qw(max sum);

has data => (
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

has _separator => (
    is => 'ro',
    isa => 'Str',
    required => 1,
    lazy => 1,
    builder => '_build__separator',
);

sub _build__cols_width {
    my ($self) = @_;

    my $result = [];

    foreach my $row (@{$self->data}) {
        for my $col_n (0 .. @{$row} - 1) {
            my $len = length($row->[$col_n]);
            $result->[$col_n] = max($result->[$col_n] // 0, $len);
        }
    }

    return $result;
}

sub _build__width {
    my ($self) = @_;

    my @cols_width = @{$self->_cols_width};
    my $margins = 2 * @cols_width;
    my $borders = @cols_width + 1;

    return $margins + $borders + sum(@cols_width);
}

sub _build__separator {
    my ($self) = @_;

    return '|' . (
        join '+',
        map { '-' x ($_ + 2) } @{$self->_cols_width}
    ) . '|' . "\n";
}

sub _header {
    my ($self) = @_;

    return '/' . ('-' x ($self->_width - 2)) . '\\' . "\n";
}

sub _footer {
    my ($self) = @_;

    return '\\' . ('-' x ($self->_width - 2)) . '/' . "\n";
}

sub _row {
    my ($self, $row_n) = @_;

    my $row = $self->data->[$row_n];

    my @cells;
    foreach my $col_n (0 .. @{$row} - 1) {
        my $width = $self->_cols_width->[$col_n];
        my $cell = sprintf(" %${width}s ", $row->[$col_n]);
        push(@cells, $cell);
    }

    return '' unless @cells;

    return '|' . (
        join '|', @cells
    ) . '|' . "\n";
}

sub to_string {
    my ($self) = @_;

    my @rows = map {$self->_row($_)} 0 .. @{$self->data} - 1;
    return '' if !@rows || !$rows[0];

    return join('', (
        $self->_header,
        join($self->_separator, @rows),
        $self->_footer,
    ));
}

1;
