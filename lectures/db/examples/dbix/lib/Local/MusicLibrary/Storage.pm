package Local::MusicLibrary::Storage;

use strict;
use warnings;

use DBI;

use Exporter 'import';
use Local::MusicLibrary::Const;
use Local::MusicLibrary::Schema;

our @EXPORT_OK = qw/store_data load_data/;

my $schema;
sub _schema { $schema ||= Local::MusicLibrary::Schema->connect('dbi:mysql:database=music_library', 'root', 'qwerty', { RaiseError => 1 }) }

=cut
$data: [ 
    { band => '..,', album => '...', ... },
    ...
]
=cut

sub store_data {
    my ($data) = @_;
    for my $row (@$data) {
        eval {
            _schema->txn_do(sub {
                my $band  = _schema->resultset('Band')->search({ name => $row->{band} })->first;
                $band = _schema->resultset('Band')->create({ name => $row->{band} }) unless $band;

                my $album = _schema->resultset('Album')->search({ name => $row->{album}, band_id => $band->id })->first;
                $album = _schema->resultset('Album')->create({ name => $row->{album}, year => $row->{year}, band_id => $band->id }) unless $album;

                my $new = 0;
                my $track = _schema->resultset('Track')->search({ name => $row->{track}, band_id => $band->id, album_id => $album->id })->first;
                unless($track) {
                    $track = _schema->resultset('Track')->create({
                        name => $row->{track}, format => $row->{format}, band_id => $band->id, album_id => $album->id});
                    $new = 1;
                }

                print "Track '".$track->name."' (".$track->id."); Album '".$album->name."' (".$album->id."); Band '".$band->name."' (".$band->id.") ".
                    ($new ? "inserted" : "already exists")."\n";
            });
        };
        if($@) {
            warn "Error while add track: $@";
        }
    }
}

my %fields_map = (
    band => 'band.name',
    year => 'album.year',
    album => 'album.name',
    track => 'me.name',
    format => 'me.format'
);

=cut
$filters: { band => '...', track => '...', ... }
$sort: band|track|...
=cut

sub load_data {
    my ($filters, $sort) = @_;

    my $result = [];
    my $rs = _schema()->resultset('Track')->search(
        {
            map { $fields_map{$_} => $filters->{$_} } keys %$filters,
        },
        {
            ($sort ? ( order_by => $fields_map{$sort} ) : ()),
            join => [qw/band album/]
        }
    );
    while(my $r = $rs->next) {
        push @$result, {
            band => $r->band->name,
            album => $r->album->name,
            year => $r->album->year,
            track => $r->name,
            format => $r->format,
        };
    }
    return $result;
}

1;
