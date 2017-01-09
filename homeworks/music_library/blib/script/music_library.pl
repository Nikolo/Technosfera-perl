#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long qw(GetOptions);
use Pod::Usage qw(pod2usage);
use FindBin;
use lib "$FindBin::Bin/../lib";
use Local::MusicLibrary;
BEGIN {if($]<5.018){package experimental; use warnings::register;}} no warnings 'experimental';

my %options;
eval { GetOptions(\%options, "band=s", "year=i", "album=s", "track=s", "format=s",
"sort=s", "columns=s", "man", "help") }; # or die "Переданы неверные параметры! Используйте --help\n";
pod2usage(-verbose => 2) if $options{man};
pod2usage(1) if $options{help};
Local::MusicLibrary->setopt(%options);
while (<>) {
	Local::MusicLibrary->add_data($_);
}
Local::MusicLibrary->print;


__END__

=encoding utf8

=head1 NAME
    Music Library - Program, that paints table of music tracks

=head1 VERSION
    Version 1.00

=head1 SYNOPSIS
./music_library.pl [options]

B<Options>:

    --help
    --band    only_this_band
    --year    only_this_year
    --album   only_this_album
    --track   only_this_track
    --format  only_this_format
    --sort    [column_for_sorting]
        columns: band, year, album, track, format
    --columns [columns_order_output]
        columns: band, year, album, track, format

=head1 OPTIONS

=over 4

=item B<--help>
    Print a brief help message and exits.

=item B<--band>
    Will be print only this band's tracks

=item B<--year>
    Will be print only this year's albums

=item B<--album>
    Will be print only this album's tracks

=item B<--track>
    Will be print only this tracks

=item B<--format>
    Will be print only this format's tracks

=item B<--sort>
    Sorting table by this column
    columns: band, year, album, track, format

=item B<--columns>
    (optional)
    Declare order of output table columns
    columns: band, year, album, track, format

=back

=head1 DESCRIPTION
    B<This program> will read the given input string(s) and create and
    output the table of music tracks.

=cut
