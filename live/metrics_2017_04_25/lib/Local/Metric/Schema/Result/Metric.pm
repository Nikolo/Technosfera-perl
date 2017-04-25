use utf8;
package Local::Metric::Schema::Result::Metric;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Local::Metric::Schema::Result::Metric

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

=head2 start

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 stop

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 query

  data_type: 'varchar'
  is_nullable: 1
  size: 1024

=head2 step_seconds

  data_type: 'integer'
  is_nullable: 0

=head2 window_seconds

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
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
    is_nullable => 1,
  },
  "query",
  { data_type => "varchar", is_nullable => 1, size => 1024 },
  "step_seconds",
  { data_type => "integer", is_nullable => 0 },
  "window_seconds",
  { data_type => "integer", is_nullable => 0 },
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

Related object: L<Local::Metric::Schema::Result::Measure>

=cut

__PACKAGE__->has_many(
  "measures",
  "Local::Metric::Schema::Result::Measure",
  { "foreign.metric_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-04-25 18:32:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nT1ODDRB6Whz/w1JfeT14g

use DateTime;
use Local::Metric::Util;

sub create_required_measures {
    my ($self) = @_;

    my $u = Local::Metric::Util->new();

    my $start = $self->next_measure_start();
    while (1) {
        my $stop = $start->clone()->add(seconds => $self->window_seconds);
        last if DateTime->compare($stop, $u->str_to_datetime($self->stop)) == 1;

        $self->create_related('measures', {
            start => $start,
            stop => $stop,
        });

        $start->add(seconds => $self->step_seconds);
    }

    return;
}

sub next_measure_start {
    my ($self) = @_;

    my $u = Local::Metric::Util->new();

    my $last_measure = $self->last_measure();

    return $last_measure
        ? $u->str_to_datetime($last_measure->start)->add(seconds => $self->step_seconds)
        : $u->str_to_datetime($self->start);
}

sub last_measure {
    my ($self) = @_;

    my @measures = $self->search_related('measures', undef, {
        order_by => {-desc => 'start'},
        rows => 1,
    })->all();

    return $measures[0];
}

1;
