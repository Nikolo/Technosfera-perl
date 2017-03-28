package Local::PrettyTable::Test;

use Test::Class::Moose;

use Local::PrettyTable;

sub _table {
    my ($self) = @_;
    
    my $matrix = [
        ['mama',    'myla',        'ramu'],
        ['uronili', 'mishku',      'na pol'],
        ['foo',     'integration', 'bar'],
    ];

    return Local::PrettyTable->new(matrix => $matrix);
}

sub test__total_margin {
    my ($self) = @_;

    my $table = Local::PrettyTable->new(
        matrix => [],
        _left_margin => 3,
        _right_margin => 4,
    );

    is($table->_total_margin, 7);

    return;
}

sub test__cols_width {
    my ($self) = @_;

    cmp_deeply($self->_table->_cols_width, [7, 11, 6]);

    return;
}

sub test__width {
    my ($self) = @_;

    is($self->_table->_width, 34);

    return;
}

sub test__header {
    my ($self) = @_;

    is(
        $self->_table->_header,
        '/' . ('-' x 32) . '\\' . "\n"
    );

    return;
}

sub test__footer {
    my ($self) = @_;

    is(
        $self->_table->_footer,
        '\\' . ('-' x 32) . '/' . "\n"
    );

    return;
}

sub test__separator {
    my ($self) = @_;

    is(
        $self->_table->_separator,
        join('', (
            '|',
                ('-' x 9),
                '+',
                ('-' x 13),
                '+',
                ('-' x 8),
            '|',
            "\n"
        )),
    );

    return;
}

sub test__row {
    my ($self) = @_;

    is(
        $self->_table->_row(1),
        "| uronili |      mishku | na pol |\n",
    );

    return;
}

sub test_to_string {
    my ($self) = @_;

    is(
        $self->_table->to_string(),
        "/--------------------------------\\\n" .
        "|    mama |        myla |   ramu |\n" .
        "|---------+-------------+--------|\n" .
        "| uronili |      mishku | na pol |\n" .
        "|---------+-------------+--------|\n" .
        "|     foo | integration |    bar |\n" .
        "\\--------------------------------/\n"
    );

    return;
}

1;
