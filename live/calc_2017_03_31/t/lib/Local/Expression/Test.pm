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

sub test_calculate {
    my ($self) = @_;

    my @cases = (
        ['3 + 4*5',   23],
        ['4*5 + 3',   23],
        ['3*4 - 2*6', 0],
    );

    foreach my $case (@cases) {
        my ($string, $expected) = @{$case};
        my $expression = Local::Expression->new(
            string => $string,
        );
        is(
            $expression->calculate(),
            $expected,
            "case `$string`"
        );
    }

    return;
}

sub test__operators_regex {
    my $expression = Local::Expression->new(
        string => '',
        _operators_info => {
            'a(' => {},
            'b]' => {},
        }
    );

    is(
        $expression->_operators_regex,
        'a\\(|b\\]'
    );

    return;
}

sub test__get_tokens {
    my ($self) = @_;

    my $expression = Local::Expression->new(
        string => '22 + 2 * 42-1',
    );

    cmp_deeply(
        $expression->_get_tokens(),
        [
            {type => 'value',    value => '22'},
            {type => 'operator', operator => '+'},
            {type => 'value',    value => '2'},
            {type => 'operator', operator => '*'},
            {type => 'value',    value => '42'},
            {type => 'operator', operator => '-'},
            {type => 'value',    value => '1'},
        ]
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

sub test__make_operation {
    my ($self) = @_;

    my $operators_stack = [
        1, 2, 3,
        {type => 'operator', operator => '+'},
    ];
    my $values_stack = [
        1, 2, 3,
        {type => 'value', value => '24'},
        {type => 'value', value => '42'},
    ];

    my $expression = Local::Expression->new(
        string => '',
    );

    $expression->_make_operation($operators_stack, $values_stack);

    cmp_deeply(
        $operators_stack,
        [1, 2, 3],
    );

    cmp_deeply(
        $values_stack,
        [
            1, 2, 3,
            {type => 'value', value => 66}
        ],
    );

    return;
}

sub test__create_value {
    my ($self) = @_;

    cmp_deeply(
        Local::Expression->_create_value(42),
        {
            value => 42,
            type => 'value',
        }
    );

    return;
}

sub test__create_operator {
    my ($self) = @_;

    cmp_deeply(
        Local::Expression->_create_operator('+'),
        {
            operator => '+',
            type => 'operator',
        }
    );

    return;
}

1;
