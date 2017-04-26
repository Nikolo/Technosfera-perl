#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use DBIx::Class::Schema::Loader qw(make_schema_at);

use Local::Metric::Config;

my $config = Local::Metric::Config->default()->get('mysql');

make_schema_at(
    'Local::Metric::Schema',
    {
        dump_directory => $FindBin::Bin . '/../lib',
    },
    [
        'DBI:mysql:database=' . $config->{db},
        $config->{user}, $config->{password},
    ],
);
