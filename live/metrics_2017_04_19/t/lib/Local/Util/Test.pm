package Local::Util::Test;

use Test::Class::Moose extends => 'Local::Test';

use Local::Util;
use DateTime;

sub test_str_to_datetime {
    my ($self) = @_;

    is(
        Local::Util->str_to_datetime('2011-02-03 04:05:06'),
        DateTime->new(
            year => 2011,
            month => 2,
            day => 3,
            hour => 4,
            minute => 5,
            second => 6,
        )
    );

    return;
}

1;
