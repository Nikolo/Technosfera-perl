package Local::Expression::Test;

use Test::Class::Moose;

use Local::Schema;

sub test_new {
    my ($self) = @_;

    my $schema = Local::Schema->new();
    my $schema_again = Local::Schema->new();

    is($schema, $schema_again);

    return;
}

1;

