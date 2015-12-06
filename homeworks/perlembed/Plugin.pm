package Plugin;

use strict;
use HTML::Escape;

our %vars = ();

sub set_var {
    my($name, $val) = @_;
    $vars{$name} = $val;
    return "";
}

sub get_var {
    my($name) = @_;
    $vars{$name};
}

sub incr_var {
    my($name, $val) = @_;
    $vars{$name} += $val;
    return "";
}

sub decr_var {
    my($name, $val) = @_;
    $vars{$name} -= $val;
    return "";
}

sub html_escape {
    my($name) = @_;
    escape_html($vars{$name});
}

1;
