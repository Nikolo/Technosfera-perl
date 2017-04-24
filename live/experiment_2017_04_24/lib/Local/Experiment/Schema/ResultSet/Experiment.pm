package Local::Experiment::Schema::ResultSet::Experiment;

use parent 'DBIx::Class::ResultSet';

sub create_by_user {
    my ($self, $number_of_queries, $a_source_id, $b_source_id) = @_;

    return $self->create({
        number_of_queries => $number_of_queries,
        a_source_id => $a_source_id,
        b_source_id => $b_source_id,
    });
}

1;
