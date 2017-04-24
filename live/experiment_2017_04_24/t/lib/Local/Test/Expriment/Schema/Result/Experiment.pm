package Local::Test::Experiment::Schema::Result::Experiment;

use Test::Class::Moose extends => 'Local::Test';

sub _create_sources {
    my ($self, $number) = @_;

    my @result;
    for (0 .. $number) {
        push(@result, $self->{schema}->resultset('Source')->create({}));
    }

    return @result;
}

sub test_start {
    my ($self) = @_;

    my ($a_source, $b_source) = $self->_create_sources(2);
    my $exp = $self->{schema}->resultset('Experiment')->create({
        a_source => $a_source,
        b_source => $b_source,
    });

    $exp->start();

    ok($exp->started);

    return;
}

1;
