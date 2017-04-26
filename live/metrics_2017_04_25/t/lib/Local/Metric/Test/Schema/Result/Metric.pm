package Local::Metric::Test::Schema::Result::Metric;

use Test::Class::Moose extends => 'Local::Test';

sub test_last_measure {
    my ($self) = @_;

    my $metric = $self->{schema}->resultset('Metric')->create({
        start => '2016-12-12 00:00:00',
        stop  => '2016-12-15 00:00:00',
        query => 'test',
    });
    my $last_measure = $metric->create_related('measures', {
        start => '2016-12-12 00:01:00',
        stop  => '2016-12-12 00:04:00',
    });
    $metric->create_related('measures', {
        start => '2016-12-12 00:00:00',
        stop  => '2016-12-12 00:03:00',
    });

    is($metric->last_measure()->id, $last_measure->id);

    return;
}

sub test_last_measure__no_measures {
    my ($self) = @_;

    my $metric = $self->{schema}->resultset('Metric')->create({
        start => '2016-12-12 00:00:00',
        stop  => '2016-12-15 00:00:00',
        query => 'test',
    });

    ok(!defined($metric->last_measure()));

    return;
}

sub test_next_measure_start {
    my ($self) = @_;

    my $metric = $self->{schema}->resultset('Metric')->create({
        start => '2016-12-12 00:00:00',
        stop  => '2016-12-15 00:00:00',
        query => 'test',
        step_seconds => 60,
    });
    $metric->create_related('measures', {
        start => '2016-12-12 00:00:00',
        stop  => '2016-12-12 00:03:00',
    });

    is($metric->next_measure_start(), '2016-12-12T00:01:00');

    return;
}

sub test_next_measure_start__no_measures {
    my ($self) = @_;

    my $metric = $self->{schema}->resultset('Metric')->create({
        start => '2016-12-12 00:00:00',
        stop  => '2016-12-15 00:00:00',
        query => 'test',
    });

    is($metric->next_measure_start(), '2016-12-12T00:00:00');

    return;
}

sub test_create_required_measures {
    my ($self) = @_;

    my $metric = $self->{schema}->resultset('Metric')->create({
        start => '2016-12-12 00:00:00',
        stop  => '2016-12-12 00:05:00',
        step_seconds => 60,
        window_seconds => 120,
        query => 'test',
    });

    $metric->create_required_measures();

    is($metric->measures->count(), 4);

    return;
}

1;
