package Local::MusicLibrary::Formatter;

use strict;
use warnings;

use Exporter 'import';
use Local::MusicLibrary::Const;

our @EXPORT_OK = qw/print_data/;

sub _get_max_lengths {
    my ($data, $columns) = @_;

    my %max_lengths = ();
    for my $row (@$data) {
        my %seen = ();
        for my $c (@{$columns}) {
            next if $seen{$c};
            $max_lengths{$c} = length($row->{$c}) if !$max_lengths{$c} || $max_lengths{$c} < length($row->{$c});
            $seen{$c} = 1;
        }
    }
    return \%max_lengths;
}

sub print_data {
    my ($data, $columns) = @_;
    return unless @$data;

    my $max_lengths = _get_max_lengths($data, $columns);
    print_head($columns, $max_lengths);

    my $first = 1;
    for my $row (@$data) {
        print_separator($columns, $max_lengths) unless $first-- == 1;

        my $str = '|';
        my @cells = ();
        for my $c (@{$columns}) {
            push @cells, sprintf(" %$max_lengths->{$c}s ", $row->{$c}); 
        }
        $str .= join('|', @cells);
        $str .= '|';
        
        print "$str\n";
    }

    print_tail($columns, $max_lengths);
}

sub print_head      { _print_border(@_, qw{/  - \\}) }
sub print_tail      { _print_border(@_, qw{\\ -  /}) }
sub print_separator { _print_border(@_, qw{|  +  |}) }

sub _print_border {
    my ($columns, $max_lengths, @syms) = @_;

    my $str = $syms[0];
    my @lines = ();
    for my $c (@{$columns}) {
        push @lines, '-' x ($max_lengths->{$c} + 2);
    }
    $str .= join($syms[1], @lines);
    $str .= $syms[2];

    print "$str\n";
}


1;
