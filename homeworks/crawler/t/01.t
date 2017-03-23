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
    10632,
    {
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/book/syntax/code' => 1,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/homeworks' => 1,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/lectures/extern-world' => 1,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/' => 1,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/lectures' => 1,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/lectures/intro' => 1,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/live/music_library_2017_03_20' => 1,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/homeworks/vfs_dumper' => 1,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/live/music_library_2017_03_21' => 1,
        'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/homeworks/music_library' => 1,
    },
];

my ($total_size, @top10) = Crawler::run(URL, 100);

is_deeply(
    [int($total_size/1024), { map {$_ => 1 } @top10 } ],
    RESULT,
    URL,
);

1;
