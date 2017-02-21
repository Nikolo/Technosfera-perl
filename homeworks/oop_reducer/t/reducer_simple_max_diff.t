use strict;
use warnings;

use Test::More tests => 6;

use Local::Reducer::MaxDiff;
use Local::Source::Text;
use Local::Row::Simple;

my $diff_reducer = Local::Reducer::MaxDiff->new(
    top => 'received',
    bottom => 'sended',
    source => Local::Source::Text->new(text =>"sended:1024,received:2048\nsended:0,received:0\ninvalid\nsended:2048,received:10240\n\nsended:2048,received:4096\nsended:foo,received:bar\n\n"),
    row_class => 'Local::Row::Simple',
    initial_value => 0,
);

my $diff_result;

$diff_result = $diff_reducer->reduce_n(1);
is($diff_result, 1024, 'diff reduced 1024');
is($diff_reducer->reduced, $diff_result, 'diff reducer saved');

$diff_result = $diff_reducer->reduce_n(2);
is($diff_result, 1024, 'diff reduced 1024');
is($diff_reducer->reduced, $diff_result, 'diff reducer saved');

$diff_result = $diff_reducer->reduce_all();
is($diff_result, 8192, 'diff reduced all');
is($diff_reducer->reduced, $diff_result, 'diff reducer saved at the end');
