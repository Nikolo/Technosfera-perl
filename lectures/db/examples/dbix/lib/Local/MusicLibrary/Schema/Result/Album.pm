use utf8;
package Local::MusicLibrary::Schema::Result::Album;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table("albums");

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "comment",
  { data_type => "text", is_nullable => 1 },
  "year",
  { data_type => "year", is_nullable => 0 },
  "band_id",
  { data_type => "integer", is_nullable => 0 },
);

__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(tracks => 'Local::MusicLibrary::Schema::Result::Track', 'album_id');
__PACKAGE__->belongs_to(band  => 'Local::MusicLibrary::Schema::Result::Band',  'band_id');

1;
