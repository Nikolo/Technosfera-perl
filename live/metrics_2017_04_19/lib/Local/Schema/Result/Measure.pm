use utf8;
package Local::Schema::Result::Measure;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Local::Schema::Result::Measure

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<measure>

=cut

__PACKAGE__->table("measure");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 metric_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 start

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 stop

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 value

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "metric_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "start",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "stop",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "value",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 metric

Type: belongs_to

Related object: L<Local::Schema::Result::Metric>

=cut

__PACKAGE__->belongs_to(
  "metric",
  "Local::Schema::Result::Metric",
  { id => "metric_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-04-19 18:58:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0Lx1jU8PgyYXLkS4xEGHTA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
