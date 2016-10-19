use strict;
use warnings;
use Test::More tests => 85;
use Test::TCP;
use Local::TCP::Calc;
use Local::TCP::Calc::Client;
use Local::TCP::Calc::Server;
use Data::Dumper;

my $server_test = Test::TCP->new(
	code => sub {
		my $port = shift;
		Local::TCP::Calc::Server->start_server($port, max_queue_task => 5, max_worker => 3, max_forks_per_task => 8, max_receiver => 2);
	},
);
my $server_test_wrong = Test::TCP->new(
	code => sub {
		my $port = shift;
		Local::TCP::Calc::Server->start_server($port, max_queue_task => 0, max_worker => 3, max_forks_per_task => 8, max_receiver => 2);
	},
);
sleep(1);
my $tests = [
	{
		name       => 'Test type 1 (3 clients)',
		multi      => 3,
		res_type   => Local::TCP::Calc::STATUS_DONE(),
		message    => ['( 1 + 2 ) * -3', '5+5 - 10 *2'],
		result     => [-9, -10],
		multiplier => 10,
	},
	{
		name       => 'Test negative type 2 (2 clients)',
		multi      => 2,
		res_type   => Local::TCP::Calc::STATUS_DONE(),
		message    => ['( 3 + 4 ('],
		result     => ['NaN'],
		multiplier => 5,
	},
];

my $srv = Local::TCP::Calc::Client->set_connect('127.0.0.1', $server_test_wrong->port);
my @res =  Local::TCP::Calc::Client->do_request($srv, Local::TCP::Calc::TYPE_START_WORK(), ['1+1']);
is($res[0], 0, 'Queue overflow');
my @servers;
for my $test (@$tests) {
	for (0..($test->{multi}-scalar(@servers))){
		eval {
			my $srv = Local::TCP::Calc::Client->set_connect('127.0.0.1', $server_test->port);
			push @servers, $srv;
		};
	}
	is(scalar(@servers), 2, $test->{name}.'. Receiver count');
	my $count=0;
	my @started_work = ();
	for my $serv (0..($test->{multi}-1)) {
		my $srv = shift(@servers);
		my @res = Local::TCP::Calc::Client->do_request($srv, Local::TCP::Calc::TYPE_START_WORK(), [(@{$test->{message}})x$test->{multiplier}]);
		if ($res[0] > 0) {
			$count++;
			push @started_work, $res[0];
		}
		unless(@servers){
			sleep(1);
		        push @servers,Local::TCP::Calc::Client->set_connect('127.0.0.1', $server_test->port);;
		}
	}
	is($count, $test->{multi}, $test->{name}.'. Work started');
	while (my $id = shift @started_work) {
		my $server = Local::TCP::Calc::Client->set_connect('127.0.0.1', $server_test->port);
		my @res = Local::TCP::Calc::Client->do_request($server, Local::TCP::Calc::TYPE_CHECK_WORK(), [$id]);
		if ($res[0] == Local::TCP::Calc::STATUS_WORK()) {
			push @started_work, $id;
		}
		else {
			is(shift @res, $test->{res_type}, $test->{name}.'. Result type');
			is(@res, @{$test->{result}} * $test->{multiplier}, $test->{name}.'. Result count');
			foreach (@res) {
				/^(.*) == (.*)$/;
				is(scalar(grep {$2 eq $_} @{$test->{result}}), 1, $test->{name}.". Wrong calc $1 != $2");
			}
		}
		sleep(1);
	}
}
done_testing();

