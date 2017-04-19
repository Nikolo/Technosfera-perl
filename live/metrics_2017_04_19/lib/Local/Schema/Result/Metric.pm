use utf8;
package Local::Schema::Result::Metric;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Local::Schema::Result::Metric

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<metric>

=cut

__PACKAGE__->table("metric");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 filter

  data_type: 'varchar'
  is_nullable: 0
  size: 1024

=head2 step_seconds

  data_type: 'integer'
  is_nullable: 0

=head2 window_seconds

  data_type: 'integer'
  is_nullable: 0

=head2 ctime

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "filter",
  { data_type => "varchar", is_nullable => 0, size => 1024 },
  "step_seconds",
  { data_type => "integer", is_nullable => 0 },
  "window_seconds",
  { data_type => "integer", is_nullable => 0 },
  "ctime",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 measures

Type: has_many

Related object: L<Local::Schema::Result::Measure>

=cut

__PACKAGE__->has_many(
  "measures",
  "Local::Schema::Result::Measure",
  { "foreign.metric_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-04-19 18:58:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GHlsa/QZOtVtMdFAc4xQHw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
