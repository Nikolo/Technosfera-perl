open(my $fh, '>', 'path/to/file');

$fh->autoflush();
$fh->print('content');

STDOUT->autoflush();
