package Local::PrettyTable::Test;

use Test::Class::Moose;

use Local::PrettyTable;

sub test_setup {
    my ($self) = @_;

    $self->{table} = Local::PrettyTable->new(
        data => [
            ['bamby', 4, 'moose'],
            ['sonic', 2, 'hedgehog'],
            ['dumbledore', 100, 'human'],
        ],
    );

    return;
}

sub test__cols_width {
    my ($self) = @_;

    cmp_deeply(
        $self->{table}->_cols_width,
        [10, 3, 8],
    );

    return;
}

sub test__width {
    my ($self) = @_;

    is(
        $self->{table}->_width,
        31,
    );

    return;
}

sub test__header {
    my ($self) = @_;

    is(
        $self->{table}->_header,
        '/' . ('-' x 29) .  '\\' . "\n"
    );

    return;
}

sub test__footer {
    my ($self) = @_;

    is(
        $self->{table}->_footer,
        '\\' . ('-' x 29) .  '/' . "\n"
    );

    return;
}

sub test__separator {
    my ($self) = @_;

    is(
        $self->{table}->_separator,
        "|------------+-----+----------|\n",
    );

    return;
}

sub test__row {
    my ($self) = @_;

    is(
        $self->{table}->_row(1),
        "|      sonic |   2 | hedgehog |\n",
    );

    return;
}

1;
