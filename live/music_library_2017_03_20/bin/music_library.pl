#!/usr/bin/env perl

use strict;
use warnings;

use Local::PrettyTable;

my $table_data = [];
while (<>) {
    chomp();
    my $row = $_;

    my ($dot, $band, $year_album, $track_format) = split(qr{/}, $row);
    my ($year, $album) = split(/ - /, $year_album);
    my ($track, $format) = split(/[.]/, $track_format);

    push(@{$table_data}, [$band, $year, $album, $track, $format]);
}

print Local::PrettyTable->new(data => $table_data)->to_string();
