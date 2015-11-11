package Local::Hackathon::Storage;

use Mouse;
use Digest::MD5 qw/md5_hex/;
use JSON::XS qw//;
use File::Path qw/make_path/;
use Time::HiRes qw/time/;
use Fcntl qw/:flock/;

has storage_dir => (is => 'ro', isa => 'Str', required => 1);

sub BUILD {
	my $self = shift;
	make_path($self->storage_dir.'/new/channels') or die $! unless -e $self->storage_dir.'/new/channels';
	make_path($self->storage_dir.'/locked/channels') or die $! unless -e $self->storage_dir.'/locked/channels';
	make_path($self->storage_dir.'/lost_and_found/channels') or die $! unless -e $self->storage_dir.'/lost_and_found/channels';
	return $self;
}

sub pack_id {
	my ($self, $id, $channel) = @_;
	die 'id is required' unless $id;
	die 'channel is required' unless $channel;
	return unpack('H*', pack('H32V/a*', $id, $channel));
}

sub unpack_id {
	my $self = shift;
	my $packed_id = shift or die 'packed_id is required';
	return unpack('H32V/a*', pack('H*', $packed_id));
}

sub check_file {

}

sub put {
	my ($self, $channel, $task)  = @_;
	die "Task required" unless $task;
	$task = JSON::XS::encode_json($task);
	my $id = md5_hex($task);
	my $channel_path = $self->storage_dir.'/new/channels/'.$channel;
	make_path($channel_path) unless -e $channel_path;
	my $file_path = $channel_path.'/'.$id;
	die 'Task already exists (file exist)' if -f $file_path;
	open(my $task_file, '>', $file_path);
	flock($task_file, LOCK_EX|LOCK_NB) or die 'Task already exists (flock fail)';
	die 'Task already exists (file not empty after flock)' if -s $file_path;
	print $task_file $task;
	flock($task_file, LOCK_UN);
	close $task_file;
	return { id => $self->pack_id($id, $channel) };
}

sub take {
	my ($self, $channel) = @_;
	my $channel_path = $self->storage_dir.'/new/channels/'. $channel;
	unless (-d $channel_path) {
		warn "Dir for $channel not exist";
		return undef;
	}
	opendir(my $dh, $channel_path) or die "Fail open dir for channel $!";
	my $min_time;
	my $min_fh;
	my $min_fname;
	while(my $fname = readdir $dh){
		my $file_path = $channel_path.'/'.$fname;
		next if -d $file_path;
		my $fh;
		unless (open($fh, '<', $file_path)){
			warn "Fail to open file $!";
			next;
		}
		unless (flock($fh, LOCK_EX|LOCK_NB)) {
			close($fh);
			next;
		}
		my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat($file_path);
		if (!$min_time or $min_time > $ctime) {
			if ($min_fh) {
				flock($min_fh, LOCK_UN);
				close($min_fh);
			}
			$min_fh = $fh;
			$min_time = $ctime;
			$min_fname = $fname;
		}
		else {
			flock($fh, LOCK_UN);
			close($fh);
		}
	}
	close($dh);

	return undef unless $min_fh;
	
	my @strs = <$min_fh>;
	my $task = eval{ JSON::XS::decode_json($strs[0]) };
	if (@strs != 1 or $@) {
		my $iter = '';
		my $lost_and_found_path = $self->storage_dir.'/lost_and_found/channels/'. $channel.'/'.$min_fname;
		$lost_and_found_path .= '_'.time() if -f $lost_and_found_path; 
		die "Cant move bad file to lost_and_found" if -f $lost_and_found_path;
		rename($channel_path.'/'.$min_fname, $lost_and_found_path);
		flock($min_fh, LOCK_UN);
		close($min_fh);
		$min_fname = undef;
		$task = undef;
	}
	else {
		my $locked_path = $self->storage_dir.'/locked/channels/'.$channel;
		make_path($locked_path) unless -d $locked_path;
		$locked_path .= '/'.$min_fname;
		die "File exists in locked dir" if -f $locked_path;
		open(my $file_to, '>>', $locked_path) or die "Can't open file in locked dir $!";
		flock($file_to, LOCK_EX|LOCK_NB) or die "Can't lock file in locked dir $!";
		die "File exist in locked dir" if -s $locked_path;
		rename($channel_path.'/'.$min_fname, $locked_path) or die "Can't move file to locked dir";
		flock($file_to, LOCK_UN);
		close($file_to);
		flock($min_fh, LOCK_UN);
		close($min_fh);
	}
	return undef unless $min_fname;
	return {id => $self->pack_id($min_fname, $channel), task => $task}; 
}

sub ack {
	my ($self, $packed_id) = @_;
	my ($id, $channel) = $self->unpack_id($packed_id);
	my $fname = $self->storage_dir.'/locked/channels/'. $channel.'/'.$id;
	die "Task $id not locked in channel $channel" unless -f $fname;
	open(my $file, "<", $fname) or die "Task $id fail to open $!";
	flock($file, LOCK_EX|LOCK_NB) or die "Task $id fail to lock $!";;
	unlink($fname) or die "Can't delete file $!";
	flock($file, LOCK_UN);
	close($file);
	return {};
}

sub release {
	my ($self, $packed_id) = @_;
	my ($id, $channel) = $self->unpack_id($packed_id);
	my $fname = $self->storage_dir.'/locked/channels/'. $channel.'/'.$id;
	die "Task $id not locked in channel $channel" unless -f $fname;
	open(my $file, "<", $fname) or die "Task $id fail to open $!";
	die "Task $id fail to lock $!" unless flock($file, LOCK_EX|LOCK_NB);
	my $new_path = $self->storage_dir.'/new/channels/'. $channel.'/'.$id;
	open(my $file_to, '>>', $new_path) or die "Can't open file in locked dir $!";
	flock($file_to, LOCK_EX|LOCK_NB) or die "Can't lock file in locked dir";
	die "File exist in locked dir" if -s $new_path;
	rename($fname, $new_path) or die "Can't move file to locked dir";
	flock($file_to, LOCK_UN);
	close($file_to);
	flock($file, LOCK_UN);
	close($file);
	return {};
}

sub requeue {
	my ($self, $packed_id, $new_channel, $task) = @_;
	$task = JSON::XS::encode_json($task);
	my $new_id = md5_hex($task);
	my ($id, $channel) = $self->unpack_id($packed_id);
	my $fname = $self->storage_dir.'/locked/channels/'.$channel.'/'.$id;
	die "Task $id not locked in channel $channel" unless -f $fname;
	open(my $file, '>', $fname) or die "Task $id fail to open $!";
	die "Task $id fail to lock $!" unless flock($file, LOCK_EX|LOCK_NB);
	my $new_path = $self->storage_dir.'/new/channels/'. $new_channel;
	make_path($new_path) unless -d $new_path;
	$new_path .= '/'.$new_id;
	open(my $file_to, '>>', $new_path) or die "Can't open file in new dir $!";
	flock($file_to, LOCK_EX|LOCK_NB) or die "Can't lock file in new dir";
	die "File exist in locked dir" if -s $new_path;
	print $file $task;
	rename($fname, $new_path);
	flock($file_to, LOCK_UN);
	close($file_to);
	flock($file, LOCK_UN);
	close($file);
	return { id => $self->pack_id($new_id, $new_channel) };
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;
