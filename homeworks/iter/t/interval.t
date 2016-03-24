use strict;
use warnings;

use Test::More tests => 10;

use DateTime;
use DateTime::Duration;
use Local::Iterator::Interval;

my $iterator;
my ($next, $end);
my $from = DateTime->new(
  year       => 1964,
  month      => 10,
  day        => 16,
  hour       => 16,
  minute     => 12,
  second     => 47,
  time_zone  => 'Asia/Taipei',
);
my $to = DateTime->new(
  year       => 1964,
  month      => 10,
  day        => 16,
  hour       => 16,
  minute     => 13,
  second     => 47,
  time_zone  => 'Asia/Taipei',
);

$iterator = Local::Iterator::Interval->new(
  from   => $from,
  to     => $to,
  step   => DateTime::Duration->new(seconds => 25),
  length => DateTime::Duration->new(seconds => 35),
);

($next, $end) = $iterator->next();
is($next->from, '1964-10-16T16:12:47');
is($next->to, '1964-10-16T16:13:22');

($next, $end) = $iterator->next();
is($next->from, '1964-10-16T16:13:12');
is($next->to, '1964-10-16T16:13:47');

($next, $end) = $iterator->next();
ok($end);

$iterator = Local::Iterator::Interval->new(
  from   => $from,
  to     => $to,
  step   => DateTime::Duration->new(seconds => 25),
);

($next, $end) = $iterator->next();
is($next->from, '1964-10-16T16:12:47');
is($next->to, '1964-10-16T16:13:12');

($next, $end) = $iterator->next();
is($next->from, '1964-10-16T16:13:12');
is($next->to, '1964-10-16T16:13:37');

($next, $end) = $iterator->next();
ok($end);
