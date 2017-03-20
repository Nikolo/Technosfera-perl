package Local::PrettyTable::Test;

use Test::Class::Moose;

use Local::PrettyTable;

sub _sample {
    return [
        ['bamby', 4, 'moose'],
        ['sonic', 2, 'hedgehog'],
        ['dumbledore', 100, 'human'],
    ],
}

sub test_new {
    my ($self) = @_;

    my $table = Local::PrettyTable->new(
        data => $self->_sample(),
    );

    ok($table);

    return;
}

sub test__cols_width {
    my ($self) = @_;

    my $table = Local::PrettyTable->new(
        data => $self->_sample(),
    );

    cmp_deeply(
        $table->_cols_width,
        [10, 3, 8],
    );

    return;
}

sub test__width {
    my ($self) = @_;

    my $table = Local::PrettyTable->new(
        data => $self->_sample(),
    );

    is(
        $table->_width,
        31,
    );

    return;
}

sub test__header {
    my ($self) = @_;

    my $table = Local::PrettyTable->new(
        data => $self->_sample(),
    );

    is(
        $table->_header,
        '/' . ('-' x 29) .  '\\'
    );

    return;
}

1;
