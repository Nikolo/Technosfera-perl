package Local::Test::Experiment::Schema::ResultSet::Experiment;

use Test::Class::Moose;

use Local::Experiment::Schema;

sub test_create_by_user {
    my ($self) = @_;

    my $created = Local::Experiment::Schema->new()->resultset('Experiment')->create_by_user(10_000, 1, 2);    

    is($created->number_of_queries, 10_000);  

    return;
}

1;
