package Local::Test;

use Test::Class::Moose;

use Local::Metric::Schema;

sub test_startup {
    my ($self) = @_;

    $self->next::method();

    $self->{schema} = Local::Metric::Schema->new();

    return;
}

sub test_setup {
    my ($self) = @_;

    $self->{schema}->txn_begin();

    return;
}

sub test_teardown {
    my ($self) = @_;

    $self->{schema}->txn_rollback();

    return;
}

1;
