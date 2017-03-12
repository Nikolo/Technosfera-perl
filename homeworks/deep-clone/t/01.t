#!/usr/bin/env perl

use 5.010;
use strict;
use warnings;
BEGIN{
    if ($] < 5.018) {
        package experimental;
        use warnings::register;
    }
}
no warnings 'experimental';

use FindBin;
use lib "$FindBin::Bin/../lib";

use DeepClone;
use Test::More;
use Test::Deep;
use Data::Dumper;
use Scalar::Util qw/looks_like_number/;

our $TESTS_CNT = 0;

sub test_deep {
    my ($t) = @_;

    my $orig = $t->{orig};
    my $cloned = DeepClone::clone($orig);
    my $test_name = $t->{name};

    if($t->{want_undef}) {
        $TESTS_CNT++;
        
        if(!defined $cloned) {
            pass($test_name.' - data schemas eq');
        } else {
            diag('undef result expected');
            fail($test_name.' - data schemas eq');
        }
    } else {
        $TESTS_CNT++;

        my $ok = eq_deeply($cloned, $orig);
        if($ok) {
            pass($test_name.' - data schemas eq');

            $TESTS_CNT++;
            if($t->{modifier}) {
                $t->{modifier}->($orig);
                my $ok = eq_deeply($cloned, $orig);
                unless($ok) {
                    pass($test_name.' - data stuctures independ');
                } else {
                    fail($test_name.' - data stuctures independ');
                }
            } else {
                pass($test_name.' - data stuctures independ');
            }
        } else {
            fail($test_name.' - data schemas eq');
        }
    }
}

my $CYCLE_ARRAY = [ 1, 2, 3 ];
$CYCLE_ARRAY->[4] = $CYCLE_ARRAY;
$CYCLE_ARRAY->[5] = $CYCLE_ARRAY;
$CYCLE_ARRAY->[6] = [ 1, 2, 3, [ { 1 => $CYCLE_ARRAY } ] ];

my $CYCLE_HASH = { a => 1, b => 2 };
$CYCLE_HASH->{c} = $CYCLE_HASH;
$CYCLE_HASH->{d} = $CYCLE_HASH;
$CYCLE_HASH->{e} = { a => 1, b => 2, [ { 1 => $CYCLE_HASH } ] };

my $TESTS = [
    {
        name => 'simple undef',
        orig => undef,
    },
    {
        name => 'simple num',
        orig => 10,
    },
    {
        name => 'simple string',
        orig => 'string',
    },
    {
        name => 'nums array',
        orig => [ 1, 2, 3, 4 ],
        modifier => sub { $_[0]->[0] = 'a' },
    },
    {
        name => 'strings array',
        orig => [ qw/a b c d e f/ ],
        modifier => sub { $_[0]->[0] = 1 },
    },
    {
        name => 'combined array',
        orig => [ 1, 2, qw/a b c d e f/, 3, 4 ],
        modifier => sub { $_[0]->[0] = undef },
    },
    {
        name => 'simple hash',
        orig => { a => 1, b => 2, c => 'x', d => 'y', 1 => 1, 2 => 2, 3 => 'v1', 4 => 'v2' },
        modifier => sub { $_[0]->{a} = 10 },
    },
    {
        name => 'array of hashes',
        orig => [ { a => 1, b => 2}, { c => 3, d => 4 } ],
        modifier => sub { $_[0]->[1]{c} = 10 },
    },
    {
        name => 'hash of arrays',
        orig => { a => [ 1, 2, 3 ], b => [ 4, 5, 6 ] },
        modifier => sub { $_[0]->{b}[1] = 10 },
    },
    {
        name => 'complex struct',
        orig => { 
            a => [ 1, 2, 3 ], 
            b => { c => 4, d => 5 }, 
            e => [ 
                { 
                    k1 => 'v1', 
                    k2 => [ qw/a b c/], 
                    k3 => undef, 
                    k4 => { kk1 => 'x', kk2 => 'y' },
                },
                [ qw/x1 x2 x3/ ],
                undef,
                1, 2, 3, qw/a b c/,
            ],
            f => {
                k1 => 'v1',
                k2 => [ qw/a b c/ ],
                k3 => undef,
                k4 => { kk1 => 'x', kk2 => 'y', kk3 => [ qw/a b c/ ], kk4 => { a => 1, b => 2 } },
            },
            g => 1,
            h => 'string',
            i => undef,
        },
        modifier => sub { $_[0]->{f}{k4}{kk3}[1] = 10 },
    },
    {
        name => 'cycle array',
        orig => $CYCLE_ARRAY,
        modifier => sub { $_[0]->[20] = 10 },
    },
    {
        name => 'cycle hash',
        orig => $CYCLE_HASH,
        modifier => sub { $_[0]->{new_key} = 10 },
    },
    {
        name => 'sub ref',
        orig => sub {},
        want_undef => 1,
    },
    {
        name => 'complex with sub ref',
        orig => [ 1, 2, 3, { a => 1, b => 2, c => [ qw/x y z/, sub {} ] } ],
        want_undef => 1,
    },
];

test_deep($_) for @$TESTS;

done_testing($TESTS_CNT);
