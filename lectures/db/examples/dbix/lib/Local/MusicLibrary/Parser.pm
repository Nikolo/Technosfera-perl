package Local::MusicLibrary::Parser;

use strict;
use warnings;

use Exporter 'import';
use Local::MusicLibrary::Const;

our @EXPORT_OK = qw/read_data/;

sub read_data {
    my $data = [];
    while(<>) {
        chomp;
        my $row = parse_str($_);
        push @$data, $row;
    }
    return $data;
}

sub parse_str {
    my ($str) = @_;

    my @parts = $str =~ m{^\./([^/]+)/(\S+) - ([^/]+)/(.+)\.([^\.]+)$};
    my %row   = map {$_ => shift @parts} COLUMNS();
    return \%row;
}

1;
