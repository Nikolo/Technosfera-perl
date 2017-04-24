package Local::Test::Experiment::Schema::ResultSet::Experiment;

use Test::Class::Moose extends => 'Local::Test';

use List::Compare;

sub _all_experiments_ids {
    my ($self) = @_;

    return [map {$_->id} $self->{schema}->resultset('Experiment')->all()];
}

sub _create_sources {
    my ($self, $number) = @_;

    my @result;
    for (0 .. $number) {
        push(@result, $self->{schema}->resultset('Source')->create({}));
    }

    return @result;
}

sub test_create_by_user {
    my ($self) = @_;

    my $before_ids = $self->_all_experiments_ids();

    my ($a_source, $b_source) = $self->_create_sources(2);
    my $created = $self->{schema}->resultset('Experiment')->create_by_user(
        10_000,
        $a_source->id,
        $b_source->id,
    );

    my $after_ids = $self->_all_experiments_ids();

    cmp_deeply(
        [List::Compare->new($before_ids, $after_ids)->get_Ronly()],
        [$created->id],
        'really created'
    );

    cmp_deeply(
        $created,
        methods(
            number_of_queries => 10_000,
            a_source => methods(id => $a_source->id),
            b_source => methods(id => $b_source->id),
        )
    );

    return;
}

sub test_start_if_possible {
    my ($self) = @_;

    $self->{schema}->resultset('Experiment')->delete();

    my %sources = (
        1 => $self->{schema}->resultset('Source')->create({capacity => 1}),
        2 => $self->{schema}->resultset('Source')->create({capacity => 2}),
        3 => $self->{schema}->resultset('Source')->create({capacity => 3}),
    );

    my %experiments = (
        1 => $self->{schema}->resultset('Experiment')->create({
            number_of_queries => 1,
            a_source => $sources{1},
            b_source => $sources{2},
        }),
        2 => $self->{schema}->resultset('Experiment')->create({
            number_of_queries => 3,
            a_source => $sources{2},
            b_source => $sources{3},
        }),
        3 => $self->{schema}->resultset('Experiment')->create({
            number_of_queries => 1,
            a_source => $sources{2},
            b_source => $sources{3},
        }),
    );

    $self->{schema}->resultset('Experiment')->start_if_possible();

    $_->discard_changes() for values %experiments;

    ok( $experiments{1}->started);
    ok(!$experiments{2}->started);
    ok(!$experiments{3}->started);

    return;
}

1;
