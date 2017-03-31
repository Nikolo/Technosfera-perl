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

sub test__get_tokens {
    my ($self) = @_;

    my $expression = Local::Expression->new(
        string => '22 + 2 * 42-1',
    );

    cmp_deeply(
        $expression->_get_tokens(),
        [qw(
            22
            +
            2
            *
            42
            -
            1
        )]
    );

    return;
}

sub test__get_tokens__bad {
    my ($self) = @_;

    my $expression = Local::Expression->new(
        string => '22 + abc',
    );

    eval {
        $expression->_get_tokens();
        1;
    } or do {
        like($@, qr{Don't know how to parse});
        return;
    };

    fail('Should die');
}

1;
