#!/usr/bin/env perl

use strict;
use lib::abs '../lib';
#BEGIN{GetOptions}
use Local::Hackathon::Worker $ARGV[0];

my $worker = Local::Hackathon::Worker->new();
$worker->run();
