use strict;
use warnings;

use Test::More tests => 2;

use Local::Subref::Schema;

unlink('subref-test.sqlite');
my $schema = Local::Subref::Schema->connect('dbi:SQLite:dbname=subref-test.sqlite', '', '');
$schema->deploy();

my $rs = $schema->resultset('User');

$rs->create({name => 'Vadim', comment => 'not a palindrome', superuser => 0});
$rs->create({name => 'Catherine', comment => 'wow', superuser => 0});
$rs->create({name => 'Alex', comment => 'xyzyx', superuser => 0});

ok( $rs->search({name => {'!=' => 'Vadim'}})->are_all_comments_palindrome());
ok(!$rs->are_all_comments_palindrome());

END {
    unlink('subref-test.sqlite') or warn $!;
}
