use strict;
use Test::More tests => 18;
use Test::Fork;
use Sfera::TCP::Calc::Client;
use Sfera::TCP::Calc::Server;
use Data::Dumper;

my $port = 8089;

fork_ok(1, sub {pass("Fork"); Sfera::TCP::Calc::Server->start_server($port)});
sleep(1);
my $tests = [
	{
		multi   => 3,
		type    => 1,
		message => '( 1 + 2 ) * -3',
		result  => -9,
	},
	{
		multi   => 2,
		type    => 2,
		message => '3 + 4 * 2 / ( 1 - 5 ) ^ 2',
		result  => '1',
	},
	{
		multi   => 2,
		type    => 2,
		message => '( 3 + 4 (',
		result  => '0',
	},
	{
		multi   => 4,
		type    => 3,
		message => '3 + 4 * 2 / ( 1 - 5 ) ^ 2',
		result  => '3 4 2 * 1 5 - 2 ^ / +',
	},
	{
		multi   => 4,
		type    => 4,
		message => '3 + 4 * 2 / ( 1 - 5 ) ^ 2',
		result  => 'Unknown type',
	},
];

my @servers;
my $tcnt = 1;
for (@$tests){
	for (0..($_->{multi}-scalar(@servers))){
		push @servers, Sfera::TCP::Calc::Client->set_connect("127.0.0.1", $port);
	}
	for my $test (0..($_->{multi}-1)){
		my $res = Sfera::TCP::Calc::Client->do_request($servers[$test], $_->{type}, $_->{message}); 
		is( $res, $_->{result}, Dumper($_)." in $test" );
		warn $tcnt++;
	}
}

push @servers, Sfera::TCP::Calc::Client->set_connect("127.0.0.1", 8089) for 1..10;
my $buf;
is( scalar(grep {eval{Sfera::TCP::Calc::Client->do_request($_, 1, "( 1 + 2 ) * 1");1}} @servers), 5, "Process count");

done_testing();

