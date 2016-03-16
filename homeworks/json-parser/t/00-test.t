#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use JSON::XS;


our $JSON = JSON::XS->new->utf8;

use Test::More tests => 1;
BEGIN { use_ok('Local::JSONParser') };

diag "Positive tests";

for my $source (
	'[]',
	# '[ ]',
	# '[ 1 ]',
	# '{}',
	# '{ }',
	# "{\n}",
	# '[{}]',
	# q/[{ "a":[ "\t\u0451\",","\"," ] }]/,

	# '{ "key1": "string value", "key2": -3.1415, "key3": ["nested array"], "key4": { "nested": "object" } }',
	# qq/{\n\t"key1" : "string value",\n\t"key2" : -3.1415,\n\t"key3" : ["nested array"],\n\t"key4":{"nested":"object"}\n}\n/,
	# qq/ { "key1":\n"string value",\n"key2":\n-3.1415,\n"key3"\n: ["nested array"],\n"key4"\n:\n{"nested":"object"}}/,
) {
	my $expect = $JSON->decode( $source );
	my $data = parse_json($source);
	is_deeply $data, $expect or do {
		diag "for source: '", explain($source),"'";
		diag "expected: ",explain($expect);
		diag "received: ",explain($data);
	};
}

diag "Negative tests";

for my $source (
	'[',
	'[{ [{]} }]',
	'{"5"',
	'{"42":null',
) {
	my ($edied,$expect) = (!eval { $JSON->decode( $source ); 1},"$@");
	my ($rdied,$res) = (!eval { parse_json( $source ); 1},"$@");
	if (!$edied) {
		diag "Malformed test: $source";
		next;
	};
	ok $rdied, 'died ok' or do {
		diag "for source: '", explain($source),"'";
		diag "expected something like: ",explain($expect);
	};
}


# is_deeply parse_json()

__DATA__
{ "key1": "string value", "key2": -3.1415, "key3": ["nested array"], "key4": { "nested": "object" } }