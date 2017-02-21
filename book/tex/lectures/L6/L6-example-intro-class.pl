{
    package A;

    sub new {
        my ($class, %params) = @_;

        return bless \%params, $class;
    }

    sub get_a {
        my ($self) = @_;

        return $self->{a};
    }
}

my $obj = A->new(a => 42);
$obj->get_a();  # 42
