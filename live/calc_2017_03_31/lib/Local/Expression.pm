package Local::Expression;

use strict;
use warnings;
use utf8;

use Mouse;

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

    foreach my $token (@{$self->_get_tokens}) {
        if ($token->{type} eq 'value') {
            push(@values_stack, $token);
        }
        elsif ($token->{type} eq 'operator') {
            push(@operators_stack, $token);
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
        \G ( \d+              )|
        \G ( $operators_regex )|
        \G ( \s+              )|
        \G ( .+               )
    }xg) {
        if (length($1)) {
            push(@result, $self->_create_value($1));
        }
        elsif (length($2)) {
            push(@result, $self->_create_operator($2));
        }
        elsif (length($3)) {
            # spaces
        }
        elsif (length($4)) {
            die "Don't know how to parse $4";
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

1;
