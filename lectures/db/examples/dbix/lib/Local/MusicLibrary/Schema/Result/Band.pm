use utf8;
package Local::MusicLibrary::Schema::Result::Band;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table("bands");

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
  { data_type => "year", is_nullable => 1 },
);

__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(albums => 'Local::MusicLibrary::Schema::Result::Album', 'band_id');
__PACKAGE__->has_many(tracks => 'Local::MusicLibrary::Schema::Result::Track', 'band_id');

1;
