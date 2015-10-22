use strict;
use warnings;

use Test::More tests => 5*2;
use File::Temp qw(tempfile);

use Local::Iterator::File;

my ($fh, $filename) = tempfile();
$fh->print("1\n2\n3");
$fh->close;

open($fh, '<', $filename);

test_iterator(
    Local::Iterator::File->new(fh => $fh),
    'by handler'
);

test_iterator(
    Local::Iterator::File->new(filename => $filename),
    'by name'
);

sub test_iterator {
    my ($iterator, $type) = @_;

    my ($next, $end);

    ($next, $end) = $iterator->next();
    is($next, 1, "next value ($type)");
    ok(!$end, "not end ($type)");

    is_deeply($iterator->all(), [2, 3], "all ($type)");

    ($next, $end) = $iterator->next();
    is($next, undef, "no value ($type)");
    ok($end, "end ($type)");
}
