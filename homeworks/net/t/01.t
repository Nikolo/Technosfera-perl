use strict;
use warnings;
use Test::More tests => 19;
use Test::TCP;
use Sfera::TCP::Calc::Client;
use Sfera::TCP::Calc::Server;
use Data::Dumper;

my $server = Test::TCP->new(
	code => sub {
		my $port = shift;
		Sfera::TCP::Calc::Server->start_server($port);
	},
);

my $tests = [
	{
		name    => 'Test type 1 (3 clients)',
		multi   => 3,
		type    => 1,
		message => '( 1 + 2 ) * -3',
		result  => -9,
	},
	{
		name    => 'Test positive type 2 (2 clients)',
		multi   => 2,
		type    => 2,
		message => '3 + 4 * 2 / ( 1 - 5 ) ^ 2',
		result  => '1',
	},
	{
		name    => 'Test negative type 2 (2 clients)',
		multi   => 2,
		type    => 2,
		message => '( 3 + 4 (',
		result  => '0',
	},
	{
		name    => 'Test type 3 (4 clients)',
		multi   => 4,
		type    => 3,
		message => '3 + 4 * 2 / ( 1 - 5 ) ^ 2',
		result  => '3 4 2 * 1 5 - 2 ^ / +',
	},
	{
		name    => 'Test type 3 (1 client)',
		multi   => 1,
		type    => 3,
		message => '- 16+ 2 * 0.3e+2 - .5 ^ ( 2 - 3 )',
		result  => ['-16 2 0.3e+2 * + .5 2 3 - ^ -', '-16 2 30 * + 0.5 2 3 - ^ -'],
	},
	{
		name    => 'Test type 3 (2 clients)',
		multi   => 2,
		type    => 3,
		message => '-1+-2+-3',
		result  => '-1 -2 + -3 +',
	},
	{
		name    => 'Test type 4 (4 clients)',
		multi   => 4,
		type    => 4,
		message => '3 + 4 * 2 / ( 1 - 5 ) ^ 2',
		result  => 'Unknown type',
	},
];
my @servers;
for my $test (@$tests) {
	push @servers, Sfera::TCP::Calc::Client->set_connect('127.0.0.1', $server->port) for 0..($test->{multi}-scalar(@servers));
	for my $serv (0..($test->{multi}-1)) {
		my $res = Sfera::TCP::Calc::Client->do_request($servers[$serv], $test->{type}, $test->{message}); 
		if (ref $test->{result}) {
			ok(scalar grep {$_ eq $res} @{$test->{result}}, $test->{name}." in $test");
		}
		else {
			is($res, $test->{result}, $test->{name}." in $test");
		}
	}
}

push @servers, Sfera::TCP::Calc::Client->set_connect('127.0.0.1', $server->port) for 1..10;
is(scalar(grep {eval {Sfera::TCP::Calc::Client->do_request($_, 1, '( 1 + 2 ) * 1'); 1}} @servers), 5, 'Process count');

done_testing();

