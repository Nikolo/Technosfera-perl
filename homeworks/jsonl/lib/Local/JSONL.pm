package Local::JSONL;

use strict;
use warnings;

=encoding utf8

=head1 NAME

Local::JSONL - JSON-lines encoder/decoder

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

    use Local::JSONL qw(
      encode_jsonl
      decode_jsonl
    );

    $string = encode_jsonl([
        {a => 1},
        {b => 2},
    ]);

    $array_ref = decode_jsonl(
        '{"a": 1}' + "\n" +
        '{"b": 2}'
    );

=cut

1;
