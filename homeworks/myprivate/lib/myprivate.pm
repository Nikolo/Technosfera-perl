package myprivate;

use strict;
use warnings;


=encoding utf8

=head1 NAME

myprivate - pragma to protect 'private' subs from calling outside of their package

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS
    use myprivate;

    sub public   { ... }
    sub _private { ... }

    no myprivate;
=cut


1;
