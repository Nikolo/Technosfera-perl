package Local::Expression::Test;

use Test::Class::Moose;

use Local::Expression;

sub test_new {
    my ($self) = @_;

    my $expression = Local::Expression->new();
    ok(defined($expression));

    return;
}

1;
