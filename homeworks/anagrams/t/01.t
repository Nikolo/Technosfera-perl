#!/usr/bin/env perl

use strict;
use warnings;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';
our $VERSION = 1.0;

use Test::More;
use Data::Dumper;

use FindBin;
use lib "$FindBin::Bin/../lib";
use Anagram;

my $EXAMPLES = [
    [ qw(пятка слиток пятак ЛиСток стул ПяТаК тяпка столик слиток) ],
    [ qw(трансцендентальный фальсифицировавший слоить солить рушиться укрыться флуктуация) ],
    [ qw(пятка пятак тяпка буковкиᑍᑏᒈ буковкиᏑፑሒ) ],
];
my $CHECK = [ map { [ @$_ ] } @$EXAMPLES ];
my $RESULTS = [
    "{'пятка' => ['пятак','пятка','тяпка'],'слиток' => ['листок','слиток','столик']}",
    "{'слоить' => ['слоить','солить']}",
    "{'пятка' => ['пятак','пятка','тяпка']}",
];

sub get_dump {
    my $data = shift;
    return Data::Dumper->new([ $data ])->Purity(1)->Terse(1)->Indent(0)->Sortkeys(1)->Dump;
}

for (my $i=0; $i<@$EXAMPLES; $i++) {
    my $j = $i+1;
    my $res = Anagram::anagram($EXAMPLES->[$i]);
    is(
        get_dump($res),
        $RESULTS->[$i],
        "example $j"
    );

    is_deeply(
        $EXAMPLES->[$i],
        $CHECK->[$i],
        "example $j source data not changed"
    );
}

# check possible global vars
is(
    get_dump( Anagram::anagram($EXAMPLES->[0]) ),
    $RESULTS->[0],
    "example 1 again"
);

done_testing();

1;
