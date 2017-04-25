package Local::Metric::Test::Schema;

use Test::Class::Moose;

use Local::Metric::Schema;

sub test_new {
    my ($self) = @_;

    ok(Local::Metric::Schema->new());

    return;
}

1;
