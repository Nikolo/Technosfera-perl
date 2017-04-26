use utf8;
package Local::Experiment::Schema::Result::Source;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Local::Experiment::Schema::Result::Source

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<source>

=cut

__PACKAGE__->table("source");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 capacity

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "capacity",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 experiment_a_sources

Type: has_many

Related object: L<Local::Experiment::Schema::Result::Experiment>

=cut

__PACKAGE__->has_many(
  "experiment_a_sources",
  "Local::Experiment::Schema::Result::Experiment",
  { "foreign.a_source_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 experiment_b_sources

Type: has_many

Related object: L<Local::Experiment::Schema::Result::Experiment>

=cut

__PACKAGE__->has_many(
  "experiment_b_sources",
  "Local::Experiment::Schema::Result::Experiment",
  { "foreign.b_source_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-04-24 19:58:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OkhNd5yM8iL3qep1W8UzKA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
