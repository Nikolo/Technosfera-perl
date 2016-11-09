package Local::MusicLibrary;

use strict;
use warnings;

use Exporter 'import';
use Local::MusicLibrary::Config qw/check_config/;
use Local::MusicLibrary::Parser qw/read_data/;
use Local::MusicLibrary::Storage qw/load_data store_data/;
use Local::MusicLibrary::Formatter qw/print_data/;

=encoding utf8

=head1 NAME

Local::MusicLibrary - core music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

our @EXPORT_OK = qw/run/;

sub run {
    my ($cfg) = @_;
    my ($store, $filter, $sort, $columns) = check_config($cfg);

    if($store) {
        my $data = read_data(); 
        store_data($data);
    }
    my $data = load_data($filter, $sort);
    print_data($data, $columns);
}

1;
