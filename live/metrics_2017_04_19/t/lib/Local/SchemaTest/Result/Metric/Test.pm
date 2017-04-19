package Local::Schema::Result::Metric::Test;

use Test::Class::Moose extends => 'Local::Test';

sub _create_metric {
    my ($self) = @_;

    return $self->{schema}->resultset('Metric')->create({
        filter => 'FILTER',
        start => '2010-01-01 00:00:00',
        stop => '2015-01-01 00:00:00',
        step_seconds => 60,
        window_seconds => 120,
    });
}

sub test_create_required_measures {
    my ($self) = @_;

    my $metric = $self->_create_metric();   

    $metric->create_required_metric_results(DateTime->new(
        year => 2010,
        month => 1,
        day => 1,
        hour => 0,
        minute => 4,
        second => 0,
    ));

    is($metric->measures->count, 3);
    
    return;
}

sub test_next_measure_stat__has_measures {
    my ($self) = @_;

    my $metric = $self->_create_metric();

    $metric->create_related('measures', {
        start => '2010-01-01 00:00:00',
        stop  => '2010-01-01 00:02:00',
    });
    $metric->create_related('measures', {
        start => '2010-01-01 00:01:00',
        stop  => '2010-01-01 00:03:00',
    });

    is($metric->next_measure_start, DateTime->new(
        year => 2010,
        month => 1,
        day => 1,
        hour => 0,
        minute => 2,
        second => 0,
    ));

    return;
}

sub test_next_measure_stat__no_measures {
    my ($self) = @_;

    my $metric = $self->_create_metric();

    is($metric->next_measure_start, DateTime->new(
        year => 2010,
        month => 1,
        day => 1,
        hour => 0,
        minute => 0,
        second => 0,
    ));

    return;
}

1;
