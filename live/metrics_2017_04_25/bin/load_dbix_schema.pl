#!/usr/bin/env perl

use strict;
use warnings;

use DBIx::Class::Schema::Loader qw(make_schema_at);

make_schema_at(
    'Local::Metric::Schema',
    {
        dump_directory => './lib',
    },
    [
        'DBI:mysql:database=metrics', 
        'metrics', 'metrics',
    ],
);
