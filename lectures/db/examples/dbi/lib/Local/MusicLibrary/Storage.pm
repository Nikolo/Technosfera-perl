package Local::MusicLibrary::Storage;

use strict;
use warnings;

use DBI;

use Exporter 'import';
use Local::MusicLibrary::Const;

our @EXPORT_OK = qw/store_data load_data/;

my $dbh;
sub _dbh { $dbh ||= DBI->connect('dbi:mysql:database=music_library', 'root', 'qwerty', { RaiseError => 1 }) }

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
            _dbh->begin_work;

            my $band_name = $row->{band};
            my $band = _dbh->selectrow_hashref("SELECT id FROM bands WHERE name = ?", {}, $band_name);
            my $band_id;
            unless($band) {
                my $sth = _dbh->prepare("INSERT INTO bands (name) VALUES (?)");
                $sth->execute($band_name);
                $band_id = _dbh->last_insert_id(undef, undef, 'bands', 'id') or die "Can't get last band id";
            } else {
                $band_id = $band->{id};
            }

            my $album_name = $row->{album};
            my $album = _dbh->selectrow_hashref("SELECT id FROM albums WHERE name = ? AND band_id = ?", {}, $album_name, $band_id);
            my $album_id;
            unless($album) {
                my $sth = _dbh->prepare("INSERT INTO albums (name,year,band_id) VALUES (?,?,?)");
                $sth->execute($album_name, $row->{year}, $band_id);
                $album_id = _dbh->last_insert_id(undef, undef, 'albums', 'id') or die "Can't get last album id";
            } else {
                $album_id = $album->{id};
            }

            my $track_name = $row->{track};
            my $track = _dbh->selectrow_hashref("SELECT id FROM tracks WHERE name = ? AND band_id = ? AND album_id = ?", {}, 
                $track_name, $band_id, $album_id);
            my ($track_id, $new);
            unless($track) {
                my $sth = _dbh->prepare("INSERT INTO tracks (name,format,band_id,album_id) VALUES (?,?,?,?)");
                $sth->execute($track_name, $row->{format}, $band_id, $album_id);
                $track_id = _dbh->last_insert_id(undef, undef, 'tracks', 'id') or die "Can't get last track id";
                $new = 1;
            } else {
                $track_id = $track->{id};
                $new = 0;
            }
            print "Track '$track_name' ($track_id); Album '$album_name' ($album_id); Band '$band_name' ($band_id) ".
                ($new ? "inserted" : "already exists")."\n";

            _dbh->commit;
        };
        if($@) {
            warn "Error while add track: $@";
            _dbh->rollback;
        }
    }
}


my %fields_map = (
    band => 'b.name',
    year => 'a.year',
    album => 'a.name',
    track => 't.name',
    format => 't.format'
);

=cut
$filters: { band => '...', track => '...', ... }
$sort: band|track|...
=cut

sub load_data {
    my ($filters, $sort) = @_;

    my $result = [];

    my $sql = "SELECT b.name AS band, a.name AS album, a.year, t.name AS track, t.format FROM tracks AS t, albums AS a, bands AS b ";
    my $where = "WHERE t.album_id = a.id AND t.band_id = b.id";
    my $order = "";
    
    my @values = ();
    if($filters) {
        for my $key (keys %$filters) {
            next unless defined $filters->{$key};
            push @values, $filters->{$key};
            $key = $fields_map{$key} or next;
            $where .= " AND $key = ?";
        }
    }
    if($sort) {
        $order = " ORDER BY $fields_map{$sort}" if $fields_map{$sort};
    }

    my $sth = _dbh->prepare($sql.$where.$order);
    $sth->execute(@values);

    while(my $row = $sth->fetchrow_hashref()) {
        push @$result, $row;
    }
    return $result;
}

1;
