package Local::PrettyTable::Test;

use Test::Class::Moose;

use Local::PrettyTable;

sub test_new {
    my ($self) = @_;

    my $table = Local::PrettyTable->new(
        data => [
            [], [], [],
        ],
    );

    ok($table);

    return;
}

1;
