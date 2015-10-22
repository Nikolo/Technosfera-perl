package Local::GetterSetter;

use strict;
use warnings;

=encoding utf8

=head1 NAME

Local::GetterSetter - getters/setters generator

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

    package Local::SomePackage;
    use Local::GetterSetter qw(x y);

    set_x(50);
    $Local::SomePackage::x; # 50

    our $y = 42;
    get_y(); # 42
    set_y(11);
    get_y(); # 11

=cut

1;
