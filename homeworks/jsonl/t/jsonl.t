use strict;
use warnings;

use Test::More tests => 2;

use Local::JSONL qw(encode_jsonl decode_jsonl);

is_deeply(
    encode_jsonl([
        {a => 1},
        {b => 2},
    ]),
    qq<{"a":1}\n{"b":2}>,
    'encode JSONL'
);

is_deeply(
    decode_jsonl(
        qq<{"a":1}\n{"b":2}>,
    ),
    [
        {a => 1},
        {b => 2},
    ],
    'decode JSONL'
);
