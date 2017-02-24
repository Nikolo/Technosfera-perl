{
    package A;

    sub set_a {
        my ($self, $value) = @_;
        $self->{a} = $value;
        return;
    }

    sub get_a {
        my ($self) = @_;
        return $self->{a};
    }
}

my $obj = bless {}, 'A';

$obj->set_a(42);
print $obj->get_a();    # 42
