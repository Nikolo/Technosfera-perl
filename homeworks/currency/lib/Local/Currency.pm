package Local::Currency;

use strict;
use warnings;

=encoding utf8

=head1 NAME

Local::Currency - currency converter

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

    use Local::Currency qw(set_rate);
    set_rate(
        usd => 1,
        rur => 65.44,
        eur => 1.2,
        # ...
    );

    my $rur = Local::Currency::usd_to_rur(42);
    my $cny = Local::Currency::gbp_to_cny(30);

=cut

1;
