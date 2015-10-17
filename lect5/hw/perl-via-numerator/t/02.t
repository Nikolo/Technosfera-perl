use strict;
use PerlIO::via::Numerator;
use Test::More;

my $test_file_name = './perl-via-numerator';

my $fh;
open($fh, '>:via(Numerator)', $test_file_name);
print $fh "test1".$/;
print $fh "test2".$/;
print $fh "test3".$/;
print $fh "test";
print $fh "4".$/;
close($fh);

open($fh, '<', $test_file_name);
my $line = <$fh>;
is($line, "1 test1\n", "");
$line = <$fh>;
is($line, "2 test2\n", "Read after write mode again");
$line = <$fh>;
is($line, "3 test3\n", "Seek in write+ mode");
$line = <$fh>;
is($line, "4 test4\n", "Seek in write+ mode again");

open($fh, '<:via(Numerator)', $test_file_name);
my $line = <$fh>;
is($line, "test1\n", "Read after write mode");
$line = <$fh>;
is($line, "test2\n", "Read after write mode again");
$line = <$fh>;
is($line, "test3\n", "Seek in write+ mode");
$line = <$fh>;
is($line, "test4\n", "Seek in write+ mode again");
close($fh);

unlink( $test_file_name );
done_testing(8);
