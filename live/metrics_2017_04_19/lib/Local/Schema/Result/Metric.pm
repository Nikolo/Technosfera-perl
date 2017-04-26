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

=head2 start

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 stop

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  is_nullable: 1

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


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-04-19 19:14:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NmlatF4oTe9NkBTi0ISJUA

use Local::Util;
use DateTime;

sub create_required_measures {
    my ($self, $until_time) = @_;

    $until_time //= DateTime->now();
    my $current_stop = $self->current_stop($until_time);

    my $start = $self->next_measure_start();

    while (1) {
        my $stop = $start->clone()->add(seconds => $self->window_seconds);
        last if DateTime->compare($stop, $current_stop) == 1;

        $self->create_related('measures', {
            start => $start,
            stop => $stop,
        });

        $start = $start->add(seconds => $self->step_seconds);
    }

    return;
}

sub current_stop {
    my ($self, $until_time) = @_;

    return $until_time unless $self->stop;

    my $stop = Local::Util->str_to_datetime($self->stop);

    return (DateTime->compare($stop, $until_time) == 1) ? $until_time : $stop;
}

sub next_measure_start {
    my ($self) = @_;

    my @measures = $self->search_related('measures', undef, {
        order_by => {-desc => 'start'},
        rows => 1,
    })->all();

    if (@measures) {
        return Local::Util->str_to_datetime($measures[0]->start)->add(seconds => $self->step_seconds);
    }

    return Local::Util->str_to_datetime($self->start);
}

1;
