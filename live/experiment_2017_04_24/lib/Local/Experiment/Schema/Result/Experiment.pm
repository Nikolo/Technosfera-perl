use utf8;
package Local::Experiment::Schema::Result::Experiment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Local::Experiment::Schema::Result::Experiment

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<experiment>

=cut

__PACKAGE__->table("experiment");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 started

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 1

=head2 number_of_queries

  data_type: 'integer'
  is_nullable: 0

=head2 a_source_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 b_source_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 a_win

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 b_win

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 draw

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "started",
  { data_type => "tinyint", default_value => 0, is_nullable => 1 },
  "number_of_queries",
  { data_type => "integer", is_nullable => 0 },
  "a_source_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "b_source_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "a_win",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "b_win",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "draw",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 a_source

Type: belongs_to

Related object: L<Local::Experiment::Schema::Result::Source>

=cut

__PACKAGE__->belongs_to(
  "a_source",
  "Local::Experiment::Schema::Result::Source",
  { id => "a_source_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 b_source

Type: belongs_to

Related object: L<Local::Experiment::Schema::Result::Source>

=cut

__PACKAGE__->belongs_to(
  "b_source",
  "Local::Experiment::Schema::Result::Source",
  { id => "b_source_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-04-24 19:58:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fsPzxQ2q7lqnItoqQB4M1w

sub start {
    my ($self) = @_;

    $self->update({started => 1});

    return;
}

1;
