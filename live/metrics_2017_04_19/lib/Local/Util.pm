package Local::Util;

use Mouse;

sub str_to_datetime {
    my ($class, $str) = @_;

    my ($date, $time) = split(/[\sT]/, $str);
    my ($year, $month, $day) = map {int($_)} split(/-/, $date);
    my ($hour, $minute, $second) = map {int($_)} split(/:/, $time);

    return DateTime->new(
        year => $year,
        month => $month,
        day => $day,
        hour => $hour,
        minute => $minute,
        second => $second,
    );
}

1;
