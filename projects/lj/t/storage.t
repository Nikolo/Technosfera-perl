use strict;
use Test::More;
use File::Path qw/rmtree/;

use_ok('Local::Hackathon::Storage');

my $st_path = '/tmp/hackathon_'.time();

die "Test dir exists" if -e $st_path;

my $storage = Local::Hackathon::Storage->new(storage_dir => $st_path);
ok(ref $storage eq 'Local::Hackathon::Storage', 'Create storage obj');
ok(-d $st_path, 'Create storage dir');
ok(-d $st_path.'/'.$_.'/channels', 'Create '.$_.' dir') for qw/locked new lost_and_found/;

my $channel_name = "foo_channel";
my $test_task = {foo => "bar"};
my $id = $storage->put($channel_name, $test_task);
ok(length($channel_name)*2+40 == length($id), 'Check id');
my ($fname,$channel) =  $storage->unpack_id($id);
ok($channel eq $channel_name, 'Check channel name');
ok(-f $st_path.'/new/channels/'.$channel.'/'.$fname, 'Check task file');

my $task = $storage->take($channel_name);
ok(ref($task) eq 'HASH', 'Take task');
ok($task->{id} eq $id, 'Id taken task');
($fname,$channel) =  $storage->unpack_id($id);
ok($channel eq $channel_name, 'Check channel name');
ok(-f $st_path.'/locked/channels/'.$channel.'/'.$fname, 'Check taken task file');
is_deeply($task->{task}, $test_task, 'Check data task');

my $task = $storage->take($channel_name);
ok(!$task, 'Task not found');

my $new_channel = 'new_channel';
my $new_task = $test_task;
$new_task->{bar} = "foo";
my $new_id = $storage->requeue($id, $new_channel, $new_task);
ok(length($new_channel)*2+40 == length($new_id), 'Check requeue id');
($fname,$channel) = $storage->unpack_id($new_id);
ok($channel eq $new_channel, 'Check new channel name');
ok(-f $st_path.'/new/channels/'.$channel.'/'.$fname, 'Check new task file');

$task = $storage->take($new_channel);
$storage->release($task->{id});
ok(-f $st_path.'/new/channels/'.$channel.'/'.$fname, 'Check release task file');

$task = $storage->take($new_channel);
$storage->ack($task->{id});
ok(!-f $st_path.'/new/channels/'.$channel.'/'.$fname, 'Check ack (new) task file');
ok(!-f $st_path.'/locked/channels/'.$channel.'/'.$fname, 'Check ack (locked) task file');

rmtree($st_path);

done_testing(21);
