package Local::Expression;

use strict;
use warnings;
use utf8;

use Mouse;

use List::Util qw(sum);

has string => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has _operators_info => (
    is => 'ro',
    isa => 'HashRef[HashRef]',
    required => 1,
    builder => '_build__operators_info',
);

sub calculate {
    my ($self) = @_;

    my @operators_stack;
    my @values_stack;
    my $op_info = $self->_operators_info();

    foreach my $token (@{$self->_get_tokens}) {
        if ($token->{type} eq 'dice') {
            push(@values_stack, $self->_create_value(
                $self->_roll($token->{number}, $token->{size})
            ));
        }
        elsif ($token->{type} eq 'value') {
            push(@values_stack, $token);
        }
        elsif ($token->{type} eq 'operator') {
            while (
                @operators_stack &&
                $operators_stack[-1]->{type} ne 'open_bracket' &&
                $op_info->{$token->{operator}}->{priority} <
                $op_info->{$operators_stack[-1]->{operator}}->{priority}
            ) {
                $self->_make_operation(
                    \@operators_stack, \@values_stack
                );
            }
            push(@operators_stack, $token);
        }
        elsif ($token->{type} eq 'open_bracket') {
            push(@operators_stack, $token);
        }
        elsif ($token->{type} eq 'close_bracket') {
            while ($operators_stack[-1]->{type} ne 'open_bracket') {
                $self->_make_operation(\@operators_stack, \@values_stack);
            }
            pop(@operators_stack);
        }
    }

    while (@operators_stack) {
        $self->_make_operation(\@operators_stack, \@values_stack);
    }

    return $values_stack[0]->{value};
}

sub _build__operators_info {
    my ($self) = @_;

    return {
        '+' => {
            priority => 0,
            func => sub {
                my ($left, $right) = @_;
                return $left + $right;
            },
        },
        '-' => {
            priority => 0,
            func => sub {
                my ($left, $right) = @_;
                return $left - $right;
            },
        },
        '*' => {
            priority => 1,
            func => sub {
                my ($left, $right) = @_;
                return $left * $right;
            },
        },
        '/' => {
            priority => 1,
            func => sub {
                my ($left, $right) = @_;
                return $left / $right;
            },
        },
    };
}

sub _operators_regex {
    my ($self) = @_;

    return
        join '|',
        map { "\Q$_\E" }
        sort
        keys %{$self->_operators_info};
}

sub _get_tokens {
    my ($self) = @_;

    my @result;
    my $operators_regex = $self->_operators_regex();

    while ($self->string =~ m{
        \G (?<dice>    (?:\d+)? d (?:\d+)? )|
        \G (?<number>  \d+                 )|
        \G (?<op>      $operators_regex    )|
        \G (?<openbr>  \(                  )|
        \G (?<closebr> \)                  )|
        \G (?<spaces>  \s+                 )|
        \G (?<garbage> .+                  )
    }xg) {
        if (length($+{dice})) {
            push(@result, $self->_create_dice($+{dice}));
        }
        elsif (length($+{number})) {
            push(@result, $self->_create_value($+{number}));
        }
        elsif (length($+{op})) {
            push(@result, $self->_create_operator($+{op}));
        }
        elsif (length($+{openbr})) {
            push(@result, $self->_create_open_bracket());
        }
        elsif (length($+{closebr})) {
            push(@result, $self->_create_close_bracket());
        }
        elsif (length($+{spaces})) {
            # spaces
        }
        elsif (length($+{garbage})) {
            die "Don't know how to parse $+{garbage}";
        }
        else {
            die q{Shouldn't be here};
        }
    }

    return \@result;
}

sub _make_operation {
    my ($self, $operators_stack, $values_stack) = @_;

    my $operator = pop(@{$operators_stack});
    my $right = pop(@{$values_stack});
    my $left = pop(@{$values_stack});

    my $operator_info = $self->_operators_info->{
        $operator->{operator}
    };

    push(
        \@{$values_stack},
        $self->_create_value(
            $operator_info->{func}->(
                $left->{value}, $right->{value}
            )
        )
    );

    return;
}

sub _roll {
    my ($self, $number, $size) = @_;

    return sum(
        map { 1 + int($size * $self->_rand()) }
        (0 .. $number - 1)
    );
}

sub _rand {
    my ($class) = @_;

    return rand();
}

sub _create_value {
    my ($class, $value) = @_;

    return {
        type => 'value',
        value => $value,
    };
}

sub _create_operator {
    my ($class, $operator) = @_;

    return {
        type => 'operator',
        operator => $operator,
    };
}

sub _create_open_bracket {
    my ($class) = @_;

    return {type => 'open_bracket'};
}

sub _create_close_bracket {
    my ($class) = @_;

    return {type => 'close_bracket'};
}

sub _create_dice {
    my ($class, $dice) = @_;

    my ($number_of_dice, $die_size) = split(/d/, $dice);

    $number_of_dice = 1 if $number_of_dice eq '';
    $die_size = 20 if $die_size eq '';

    return {
        type => 'dice',
        number => $number_of_dice,
        size => $die_size,
    };
}

1;
