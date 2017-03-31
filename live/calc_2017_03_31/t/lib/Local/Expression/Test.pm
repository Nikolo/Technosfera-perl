package Local::Expression::Test;

use Test::Class::Moose;

use Local::Expression;

sub test_new {
    my ($self) = @_;

    my $expression = Local::Expression->new(
        string => '2+2',
    );

    is($expression->string, '2+2');

    return;
}

1;
