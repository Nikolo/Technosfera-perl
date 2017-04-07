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

    local *{Local::Expression::_rand} = sub {
        my ($class) = @_;

        return 0.5;
    };

    my @cases = (
        ['0',             0],
        ['0 * 100',       0],
        ['3 + 4*5',       23],
        ['4*5 + 3',       23],
        ['(3*4 - 2*6)',   0],
        ['(2+6) / (4+4)', 1],
        ['1d20 + 2d8',    21],
        ['100d100 / 100', 50],
    );

    foreach my $case (@cases) {
        my ($string, $expected) = @{$case};
        my $expression = Local::Expression->new(
            string => $string,
        );
        is(
            $expression->calculate(),
            $expected,
            "$string = $expected"
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
        string => 'd + 2d8 * (42-1)',
    );

    cmp_deeply(
        $expression->_get_tokens(),
        [
            {type => 'dice', number => 1, size => 20},
            {type => 'operator', operator => '+'},
            {type => 'dice', number => 2, size => 8},
            {type => 'operator', operator => '*'},
            {type => 'open_bracket'},
            {type => 'value',    value => '42'},
            {type => 'operator', operator => '-'},
            {type => 'value',    value => '1'},
            {type => 'close_bracket'},
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

sub test__create_open_bracket {
    my ($self) = @_;

    cmp_deeply(
        Local::Expression->_create_open_bracket(),
        {
            type => 'open_bracket',
        }
    );

    return;
}

sub test__create_close_bracket {
    my ($self) = @_;

    cmp_deeply(
        Local::Expression->_create_close_bracket(),
        {
            type => 'close_bracket',
        }
    );

    return;
}

sub test__create_dice {
    my ($self, $dice) = @_;

    my @cases = (
        ['2d10', {type => 'dice', number => '2', size => '10'}],
        ['d30',  {type => 'dice', number => '1', size => '30'}],
        ['3d',   {type => 'dice', number => '3', size => '20'}],
    );

    foreach my $case (@cases) {
        my ($string, $expected) = @{$case};
        cmp_deeply(
            Local::Expression->_create_dice($string),
            $expected,
            "$string"
        );
    }


    return;
}

1;
