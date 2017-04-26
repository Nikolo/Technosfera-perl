#!/usr/bin/env perl

use strict;
use warnings;

use Local::Schema;

my $schema = Local::Schema->new();

foreach my $metric ($schema->resultset('Metric')->all()) {
    $metric->create_required_measures();
}
