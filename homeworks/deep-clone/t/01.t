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
use Data::Dumper;
use Scalar::Util qw/looks_like_number/;

our %seen_refs = ();
sub deep_compare {
    my ($orig, $cloned) = @_;

    local %seen_refs = %seen_refs;
    if(ref $orig && ref $cloned) {
        if($orig eq $cloned) {
            return (0, 'has same refs');
        } else {
            return 1 if $seen_refs{$orig};
            $seen_refs{$orig} = 1;

            if(ref $orig eq 'ARRAY' && ref $cloned eq 'ARRAY') {
                if(@$orig != @$cloned) {
                    return (0, 'arrays length diff');
                } else {
                    for(0..$#$orig) {
                        my ($r, $msg) = deep_compare($orig->[$_], $cloned->[$_]);
                        return $r, $msg unless $r;
                    }
                }
                return 1;
            }
            if(ref $orig eq 'HASH' && ref $cloned eq 'HASH') {
                if(keys %$orig != keys %$cloned) {
                    return (0, 'hashes keys count diff');
                } else {
                    for(sort keys %$orig) {
                        unless(exists $cloned->{$_}) {
                            return (0, 'hash key not exists');
                        } else {
                            my ($r, $msg) = deep_compare($orig->{$_}, $cloned->{$_});
                            return $r, $msg unless $r;
                        }
                    }
                }
                return 1;
            }
            return (0, 'different or illegal refs');
        }
    } elsif (!ref $orig && !ref $cloned) {
        if(!defined $orig) {
            return defined $cloned ? (0, 'not undef') : 1;
        } elsif(looks_like_number($orig)) { 
            return looks_like_number($cloned) && $orig == $cloned ? 1 : (0, 'nums not eq');
        } else {
            return $orig eq $cloned ? 1 : (0, 'strings not eq');
        }
    } else {
        return (0, 'different types');
    }
}

sub test_deep {
    my ($orig, $cloned, $test_name, $want_undef) = @_;
    if($want_undef) {
        if(!defined $cloned) {
            pass($test_name);
        } else {
            diag('undef result expected');
            fail($test_name);
        }
    } else {
        my ($r,$msg) = deep_compare($orig, $cloned);
        if($r) {
            pass($test_name);
        } else {
            diag('deep compare fail: '.$msg);
            fail($test_name);
        }
    }
}

my $CYCLE_ARRAY = [ 1, 2, 3 ];
$CYCLE_ARRAY->[4] = $CYCLE_ARRAY;
$CYCLE_ARRAY->[5] = $CYCLE_ARRAY;

my $CYCLE_HASH = { a => 1, b => 2 };
$CYCLE_HASH->{c} = $CYCLE_HASH;
$CYCLE_HASH->{d} = $CYCLE_HASH;

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
    },
    {
        name => 'strings array',
        orig => [ qw/a b c d e f/ ],
    },
    {
        name => 'combined array',
        orig => [ 1, 2, qw/a b c d e f/, 3, 4 ],
    },
    {
        name => 'simple hash',
        orig => { a => 1, b => 2, c => 'x', d => 'y', 1 => 1, 2 => 2, 3 => 'v1', 4 => 'v2' },
    },
    {
        name => 'array of hashes',
        orig => [ { a => 1, b => 2}, { c => 3, d => 4 } ],
    },
    {
        name => 'hash of arrays',
        orig => { a => [ 1, 2, 3 ], b => [ 4, 5, 6 ] },
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
                k4 => { kk1 => 'x', kk2 => 'y', kk3 => [ qw/a b c/], kk4 => { a => 1, b => 2 } },
            },
            g => 1,
            h => 'string',
            i => undef,
        },
    },
    {
        name => 'cycle array',
        orig => $CYCLE_ARRAY,
    },
    {
        name => 'cycle hash',
        orig => $CYCLE_HASH,
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

my $TESTS_CNT = @$TESTS;

for my $t (@$TESTS) {
    test_deep($t->{orig}, DeepClone::clone($t->{orig}), $t->{name}, $t->{want_undef});
}

done_testing($TESTS_CNT);
