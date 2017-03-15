#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 26;
#use IPC::Run qw/run start finish/;
use IPC::Open3;
use Data::Dumper;

my ($stdin, $stdout, $stderr) = ("","","");
use Symbol 'gensym'; $stderr = gensym;
my $buf;
$ENV{PERLIO} = 'unix';

my $pid = open3($stdin, $stdout, $stderr, '/usr/bin/perl', 'bin/stdin.pl', '--file=1');
is(!$pid, '', "Started stdin.pl");
sysread($stdout, $buf, 1024);
chomp($buf);
is($buf, 'Get ready', 'Prompt ok');
print $stdin "asd\nasdf\nasdfg\n";
close($stdin);
sysread($stdout, $buf, 1024);
chomp($buf);
is($buf, '12 3 4', 'Simple start ok');
sysread($stderr, $buf, 1024);
is($buf, '', 'Simple start stderr ok');
is(waitpid($pid, 0), $pid, 'process exit by eof');
is(-f "1", 1, 'File exists');
is(-s _, 15, "File size ok");
unlink "1";

$pid = open3($stdin, $stdout, $stderr, '/usr/bin/perl', 'bin/stdin.pl', '--file=1');
is(!$pid, '', "Started stdin.pl");
sysread($stdout, $buf, 1024);
chomp($buf);
is($buf, 'Get ready', 'Prompt ok');
print $stdin "asd\nasdf\nasdfg\n";
is(kill('INT', $pid), 1, 'kill sent');
is(kill(0, $pid), 1, 'Process work after one kill');
print $stdin "asd\nasdf\nasdfg\n";
close($stdin);
sysread($stdout, $buf, 1024);
chomp($buf);
is($buf, '24 6 4', 'Signaled ok');
sysread($stderr, $buf, 1024);
$buf =~ s/ at .*$//sg;
is($buf, 'Double Ctrl+C for exit', 'signaled stderr ok');
is(waitpid($pid, 0), $pid, 'process exit by eof');
is(-f "1", 1, 'File exists');
is(-s _, 30, "File size ok");
unlink "1";

$pid = open3($stdin, $stdout, $stderr, '/usr/bin/perl', 'bin/stdin.pl', '--file=1');
is(!$pid, '', "Started stdin.pl");
sysread($stdout, $buf, 1024);
chomp($buf);
is($buf, 'Get ready', 'Prompt ok');
print $stdin "asd\nasdf\nasdfg\n";
sleep(1);
is(kill('INT', $pid), 1, 'kill sent');
is(kill('INT', $pid), 1, 'kill sent');
is(kill(-1, $pid), 0, 'Process work after one kill');
print $stdin "asd\nasdf\nasdfg\n";
close($stdin);
sysread($stdout, $buf, 1024);
chomp($buf);
is($buf, '12 3 4', 'Signaled ok');
sysread($stderr, $buf, 1024);
$buf =~ s/ at .*$//sg;
is($buf, 'Double Ctrl+C for exit', 'signaled stderr ok');
is(waitpid($pid, 0), $pid, 'process exit by eof');
is(-f "1", 1, 'File exists');
is(-s _, 15, "File size ok");
unlink "1";

