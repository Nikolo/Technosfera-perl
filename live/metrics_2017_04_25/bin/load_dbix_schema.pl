#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use DBIx::Class::Schema::Loader qw(make_schema_at);

make_schema_at(
    'Local::Metric::Schema',
    {
        dump_directory => $FindBin::Bin . '/../lib',
    },
    [
        'DBI:mysql:database=metrics', 
        'metrics', 'metrics',
    ],
);
