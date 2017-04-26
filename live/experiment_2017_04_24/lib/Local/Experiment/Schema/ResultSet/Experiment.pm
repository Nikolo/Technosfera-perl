package Local::Experiment::Schema::ResultSet::Experiment;

use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';

sub create_by_user {
    my ($self, $number_of_queries, $a_source_id, $b_source_id) = @_;

    return $self->create({
        number_of_queries => $number_of_queries,
        a_source_id => $a_source_id,
        b_source_id => $b_source_id,
    });
}

sub start_if_possible {
    my ($self) = @_;

    my @experiments = $self->search({}, {order_by => 'id'})->all();
    my %capacities;

    foreach my $experiment (@experiments) {
        my $overflow = 0;
        foreach my $source ($experiment->a_source, $experiment->b_source) {
            $capacities{$source->id} //= $source->capacity;
            $capacities{$source->id} -= $experiment->number_of_queries;
            $overflow = 1 if $capacities{$source->id} < 0;
        }

        $experiment->start() if !$overflow && !$experiment->started;
    }

    return;
}

1;
