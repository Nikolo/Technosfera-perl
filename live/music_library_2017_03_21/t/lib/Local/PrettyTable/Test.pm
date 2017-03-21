package Local::PrettyTable::Test;

use Test::Class::Moose;

use Local::PrettyTable;

sub test_new {
    my ($self) = @_;

    my $table = Local::PrettyTable->new(
        matrix => [[], [], []],
    );

    ok(defined $table);

    return;
}

sub test__cols_width {
    my ($self) = @_;

    my $matrix = [
        ['mama',    'myla',        'ramu'],
        ['uronili', 'mishku',      'na pol'],
        ['foo',     'integration', 'bar'],
    ];

    my $table = Local::PrettyTable->new(matrix => $matrix);
    
    cmp_deeply($table->_cols_width, [7, 11, 6]);

    return;
}

sub test__width {
    my ($self) = @_;

    my $matrix = [
        ['mama',    'myla',        'ramu'],
        ['uronili', 'mishku',      'na pol'],
        ['foo',     'integration', 'bar'],
    ];

    my $table = Local::PrettyTable->new(matrix => $matrix);
    
    is($table->_width, 34);

    return;
}

1;
