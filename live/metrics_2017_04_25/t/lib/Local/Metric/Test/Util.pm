package Local::Metric::Test::Util;

use Test::Class::Moose extends => 'Local::Test';

use Local::Metric::Util;

sub test_str_to_datetime {
    my ($self) = @_;

    my $dt = Local::Metric::Util->new->str_to_datetime(
        '2016-01-01 12:13:14',
    );

    cmp_deeply(
        $dt,
        methods(
            year => 2016,
            month => 1,
            day => 1,
            hour => 12,
            minute => 13,
            second => 14,
        ),
    );

    return;
}

1;
