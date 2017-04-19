#!/usr/bin/env perl

use strict;
use warnings;

use DBIx::Class::Schema::Loader qw(make_schema_at);

make_schema_at(
    'Local::Schema',
    {
        debug => 1,
        dump_directory => './lib',
    },
    [
        'DBI:mysql:database=metrics;host=localhost',
        'metrics', 'metrics'
    ],
);
