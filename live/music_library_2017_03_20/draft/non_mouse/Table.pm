package Table;

use parent 'Object';

sub init {
    my ($self) = @_;

    die unless defined $self->{data};

    return;
}

sub data {
    my ($self) = @_;

    return $self->{data};
}

1;

