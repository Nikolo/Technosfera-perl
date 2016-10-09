use strict;

my $rand1 = int(rand(1000));
my $rand2 = int(rand(10));

my $exclusive = exists $ENV{TEST_REQUIRED} || exists $ENV{TEST_NOSPACE} || exists $ENV{TEST_UNARY};
my $do_required = !$exclusive || !!$ENV{TEST_REQUIRED};
my $do_nospace = !$exclusive || !!$ENV{TEST_NOSPACE};
my $do_unary = !$exclusive || !!$ENV{TEST_UNARY};

my $required = {
	$do_required ? (
		good => [
			[ '1',                                  '1',                            '1'     ],
			[ '1 + 1',                              '1 1 +',                        '2'     ],
			[ '1 + 2 * 3',                          '1 2 3 * +',                    '7'     ],
			[ '(1 + 2) * 3',                        '1 2 + 3 *',                    '9'     ],
			[ '1 + 2 * 3 ^ 4',                      '1 2 3 4 ^ * +',                '163'   ],
			[ '11 + 22 * 33 ^ 2',                   '11 22 33 2 ^ * +',             '23969' ],
			[ '1.5 * (13.3 - 8) / 9.0 ^ 0.5',       '1.5 13.3 8 - * 9 0.5 ^ /',     '2.65'  ],

			# numbers
			[ '1 + 0.5',                            '1 0.5 +',                      '1.5'   ],
			[ '1 + .5',                             '1 0.5 +',                      '1.5'   ],
			[ '1 + .5e0',                           '1 0.5 +',                      '1.5'   ],
			[ '1 + .5e1',                           '1 5 +',                        '6'     ],
			[ '1 + .5e+1',                          '1 5 +',                        '6'     ],
			[ '1 + .5e-1',                          '1 0.05 +',                     '1.05'  ],
			[ '1 + .5e+1 * 2',                      '1 5 2 * +',                    '11'    ],
			[ '42 * 0',                             '42 0 *',                       '0'     ],
			[ '0 / 42',                             '0 42 /',                       '0'     ],
			[ "$rand1 * $rand2",                    "$rand1 $rand2 *",              $rand1*$rand2 ],
		],

		bad => [
			[ '1ee3',                               qr/^Error/,                     'NaN' ],
			[ '1.3.5',                              qr/^Error/,                     'NaN' ],
		],
	) : ()
};

my $nospace = {
	good => [
		(map {
			+[ join('',split /\s+/,$_->[0]),$_->[1], $_->[2] ]
		} @{ $required->{good} }),
	],
	bad => [
		(map {
			+[ join('',split /\s+/,$_->[0]),$_->[1], $_->[2] ]
		} @{ $required->{bad} }),

	],
};

my $unary = {
	good => [
		[ '-1',                                 '1 U-',                         '-1'  ],
		[ '+1',                                 '1 U+',                         '1'  ],
		[ '-1 + 1',                             '1 U- 1 +',                     '0'   ],
		[ '-1 + - 1',                           '1 U- 1 U- +',                  '-2'  ],
		[ '-1 + - 1',                           '1 U- 1 U- +',                  '-2'  ],
		[ '-1 + - + 1',                         '1 U- 1 U+ U- +',               '-2'  ],
		[ '-(-1+-2)*-2^-3',                     '1 U- 2 U- + U- 2 3 U- ^ U- *', '-0.375'  ],
		[ '- 16 + 2 * 0.3e+2 - .5 ^ ( 2 - 3 )', '16 U- 2 30 * + 0.5 2 3 - ^ -', '42'    ],
	],
	bad => [
		[ '- -',                                 qr/^Error/,                    'NaN' ],
	],
};

push @{$unary->{good}},(map {
	+[ join('',split /\s+/,$_->[0]),$_->[1], $_->[2] ]
} @{ $unary->{good} });
push @{$unary->{bad}},(map {
	+[ join('',split /\s+/,$_->[0]),$_->[1], $_->[2] ]
} @{ $unary->{bad} });

return {
# required suite for 5
	# common w spaces
	required => $required,

# required suite for +2
	nospace => $nospace,

# required suite for +3
	unary   => $unary,
};
