package Object;

sub new {
    my ($class, %params) = @_;

    my $object = \%params;
    bless($object, $class);
    $object->init();

    return $object;
}

sub init {
    my ($self, %params) = @_;

    return;
}

1;


