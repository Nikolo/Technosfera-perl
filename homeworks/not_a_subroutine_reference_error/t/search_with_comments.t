use strict;
use warnings;

use Test::More tests => 1;

use Local::Subref::Schema;

unlink('subref-test.sqlite');
my $schema = Local::Subref::Schema->connect('dbi:SQLite:dbname=subref-test.sqlite', '', '');
$schema->deploy();

my $rs = $schema->resultset('User');

$rs->create({name => 'Admin', superuser => 1});
$rs->create({name => 'Vadim', comment => '', superuser => 0});
$rs->create({name => 'Catherine', comment => 'wife', superuser => 0});

is($rs->search_with_comment->count(), 1);

END {
    unlink('subref-test.sqlite') or warn $!;
}
