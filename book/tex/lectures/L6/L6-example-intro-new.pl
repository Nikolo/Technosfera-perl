{
    package A;
    sub new {
        my ($class, %params) = @_;

        return bless \%params, $class;
    }
}

my $obj = A->new(a => 1, b => 2);

print $obj->{a};    # 1
print $obj->{b};    # 2
