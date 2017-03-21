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
        '/' . ('-' x 32) . '\\'
    );

    return;
}

sub test__footer {
    my ($self) = @_;

    is(
        $self->_table->_footer,
        '\\' . ('-' x 32) . '/'
    );

    return;
}

1;
