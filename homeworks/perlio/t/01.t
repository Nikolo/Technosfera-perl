use strict;
use PerlIO::via::Numerator;
use Test::More;

my $test_file_name = './perl-via-numerator';

my $fh;
open($fh, '>:via(Numerator)', $test_file_name);
print $fh "test1".$/;
print $fh "test";
print $fh "3".$/;
seek($fh, -2, 1);
print $fh "2".$/;
close($fh);

open($fh, '>>:via(Numerator)', $test_file_name);
print $fh "test9".$/;
print $fh "test";
print $fh "4".$/;
close($fh);

open($fh, '+<:via(Numerator)', $test_file_name);
my $line = <$fh>;
is($line, "test1\n", "Write mode");
$line = <$fh>;
is($line, "test2\n", "Seek in write mode");
print $fh "test3";
close($fh);

open($fh, '<:via(Numerator)', $test_file_name);
my $line = <$fh>;
is($line, "test1\n", "Read after write and append mode");
$line = <$fh>;
is($line, "test2\n", "Read after write and append mode (test2)");
$line = <$fh>;
is($line, "test3\n", "Read after write, append and read+ mode");
$line = <$fh>;
is($line, "test4\n", "Read after write, append and read+ mode (test2)");
close($fh);

open($fh, '+>:via(Numerator)', $test_file_name);
print $fh "test1".$/;
print $fh "test2".$/;
print $fh "test3".$/;
print $fh "test4".$/;
seek($fh, 0, 0);
my $line = <$fh>;
is($line, "test1\n", "Write+ mode");
$line = <$fh>;
is($line, "test2\n", "Write+ mode again");
print $fh "test8";
seek($fh, -1, 1);
print $fh "3";
seek($fh, 0, 2);
print $fh "test5";
close($fh);

open($fh, '<:via(Numerator)', $test_file_name);
my $line = <$fh>;
is($line, "test1\n", "Read after write mode");
$line = <$fh>;
is($line, "test2\n", "Read after write mode again");
$line = <$fh>;
is($line, "test3\n", "Seek in write+ mode");
$line = <$fh>;
is($line, "test4\n", "Seek in write+ mode again");
seek($fh, -8, 1);
$line = <$fh>;
is($line, "test4\n", "Seek in read mode");
$line = <$fh>;
is($line, "test5", "Read without newline");
close($fh);

unlink( $test_file_name );
done_testing(14);
