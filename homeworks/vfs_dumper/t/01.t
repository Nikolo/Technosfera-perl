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

use Test::More tests => 4;
use Data::Dumper;

use FindBin;
use lib "$FindBin::Bin/../lib";
use VFS;

sub read_file {
	open my $file, "<", "$_[0]" or die "Can't open file $_[0]";
	local $/ = undef;
	return <$file>;
}

sub is_died(&) {
	eval { $_[0]->(); 1; } and return;
	(my $message = $@) =~ s{ at [^ ]+ line \d+\.}{};
	chomp $message;
	return $message;
}

use constant EXAMPLE1   => q({"mode":{"user":{"write":true,"read":true,"execute":true},"other":{"execute":true,"read":true,"write":false},"group":{"write":true,"read":true,"execute":true}},"type":"directory","list":[{"name":"Документы","list":[{"hash":"494bf971d20f6db1822754b89cc26cbb2d19cee3","type":"file","mode":{"other":{"execute":false,"read":true,"write":false},"user":{"execute":false,"write":true,"read":true},"group":{"read":true,"write":true,"execute":false}},"size":45056,"name":"Договор аренды.docx"},{"size":168756,"name":"предложение о работе.docx","type":"file","hash":"35472bcf3693bee9f3d23f0f07744f2be4741b2c","mode":{"user":{"write":true,"read":true,"execute":false},"other":{"execute":false,"write":false,"read":true},"group":{"execute":false,"write":true,"read":true}}}],"type":"directory","mode":{"user":{"read":true,"write":true,"execute":true},"other":{"write":false,"read":true,"execute":true},"group":{"execute":true,"write":true,"read":true}}},{"mode":{"group":{"execute":true,"read":true,"write":true},"other":{"execute":true,"read":true,"write":false},"user":{"execute":true,"read":true,"write":true}},"list":[{"name":"DSC_0003.JPG","size":660348,"mode":{"group":{"execute":false,"write":true,"read":true},"other":{"execute":false,"write":false,"read":true},"user":{"write":true,"read":true,"execute":false}},"type":"file","hash":"e3af440cfe876329544451c34b2caaa264027470"},{"hash":"58ee0cc0a37c6a6c021d677f7eab0e2d373458cd","type":"file","mode":{"user":{"write":true,"read":true,"execute":false},"other":{"execute":false,"read":true,"write":false},"group":{"execute":false,"write":true,"read":true}},"size":572121,"name":"DSC_0004.JPG"}],"type":"directory","name":"Фото"},{"type":"directory","list":[{"mode":{"other":{"read":true,"write":false,"execute":false},"user":{"read":true,"write":true,"execute":false},"group":{"read":true,"write":true,"execute":false}},"hash":"0d6297cfe807534f80dc855a2cf338c109f57275","type":"file","name":"steam_latest.deb","size":2521706}],"mode":{"other":{"execute":true,"write":false,"read":true},"user":{"execute":true,"write":true,"read":true},"group":{"write":true,"read":true,"execute":true}},"name":"Файлы"}],"name":"root"});

is_deeply (
	VFS::parse(read_file("$FindBin::Bin/../data/example1.bin")),
	JSON::XS::decode_json(EXAMPLE1),
	"Test 1"
);

is_deeply (
	VFS::parse(read_file("$FindBin::Bin/../data/example2.bin")),
	{},
	"Test 2"
);

is (
	is_died(sub { VFS::parse(read_file("$FindBin::Bin/../data/example4.bin")); }),
	"The blob should start from 'D' or 'Z'",
	"Test 3"
);

is (
	is_died(sub { VFS::parse(read_file("$FindBin::Bin/../data/example5.bin")); }),
	"Garbage ae the end of the buffer",
	"Test 4"
);

1;
