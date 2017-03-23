#!/usr/bin/env perl

use strict;
use warnings;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';
our $VERSION = 1.0;

use Test::More tests => 1;
use Data::Dumper;

use FindBin;
use lib "$FindBin::Bin/../lib";
use Crawler;

use constant URL => 'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/';

use constant RESULT => [
    10565,
    {
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/book/syntax/code' => 168,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/homeworks' => 79,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/lectures/extern-world' => 69,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/lectures' => 68,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/' => 65,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/lectures/web' => 60,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/homeworks/vfs_dumper' => 60,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/lectures/intro' => 59,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/live/music_library_2017_03_20' => 58,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/lectures/net' => 57,
    },
];

my ($total_size, $top10) = Crawler::run(URL, 100);

is_deeply(
    [int($total_size/1024), { map {$_->[1] /= 1024; $_->[0] => int($_->[1]) } @$top10 } ],
    RESULT,
    URL,
);

1;
