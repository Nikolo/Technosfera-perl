package Local::Test;

use Test::Class::Moose;

use Local::Schema;

sub test_setup {
    my ($self) = @_;

    $self->{schema} = Local::Schema->new();
    $self->{schema}->txn_begin();

    return;
}

sub test_teardown {
    my ($self) = @_;

    $self->{schema}->txn_rollback();

    return;
}

1;
