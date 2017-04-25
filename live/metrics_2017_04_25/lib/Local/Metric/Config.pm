package Local::Metric::Config;

use strict;
use warnings;

use Mouse;

use File::Basename;
use YAML::Tiny;

has fh => (
    is => 'ro',
    isa => 'FileHandle',
    lazy => 1,
    builder => '_build_fh',
);

has filename => (
    is => 'ro',
    isa => 'Str',
);

has str => (
    is => 'ro',
    isa => 'Str',
    required => 1,
    lazy => 1,
    builder => '_build_str',
);

has _data => (
    is => 'ro',
    isa => 'HashRef',
    required => 1,
    lazy => 1,
    builder => '_build__data',
);

my $DEFAULT_CONFIG;
sub default {
    my ($class) = @_;

    if (!defined($DEFAULT_CONFIG)) {
        $DEFAULT_CONFIG = $class->new(
            filename => dirname(__FILE__) . '/../../../etc/config.yaml'
        );
    }

    return $DEFAULT_CONFIG;
}

sub _build_fh {
    my ($self) = @_;

    open(my $fh, '<', $self->filename)
        or die q{Can't open } . $self->filename;

    return $fh;
}

sub _build_str {
    my ($self) = @_;

    my $fh = $self->fh;

    return join('', <$fh>);
}

sub _build__data {
    my ($self) = @_;

    return YAML::Tiny->read_string($self->str)->[0];
}

sub get {
    my ($self, $field) = @_;

    return $self->_data->{$field};
}

1;
