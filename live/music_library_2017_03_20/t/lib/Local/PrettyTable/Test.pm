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

sub test__row__no_cols {
    my ($self) = @_;

    my $table = Local::PrettyTable->new(data => [[], [], []]);

    is(
        $table->_row(1),
        '',
    );

    return;
}

sub test_to_string {
    my ($self) = @_;

    is(
        $self->{table}->to_string(),
        "/-----------------------------\\\n" .
        "|      bamby |   4 |    moose |\n"  .
        "|------------+-----+----------|\n"  .
        "|      sonic |   2 | hedgehog |\n"  .
        "|------------+-----+----------|\n"  .
        "| dumbledore | 100 |    human |\n"  .
        "\\-----------------------------/\n"
    );

    return;
}

sub test_to_string__no_rows {
    my ($self) = @_;

    my $table = Local::PrettyTable->new(data => []);

    is($table->to_string, '');

    return;
}

sub test_to_string__no_cols {
    my ($self) = @_;

    my $table = Local::PrettyTable->new(data => [[], [], []]);

    is($table->to_string, '');

    return;
}

1;
