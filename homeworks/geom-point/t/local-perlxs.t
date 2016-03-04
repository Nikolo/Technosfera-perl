# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl Local-perlxs.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More tests => 14;
BEGIN { use_ok('Local::perlxs') };
is(Local::perlxs::distance_point(1,1,1,3), 2);
my($dist, $dx, $dy) = Local::perlxs::distance_ext_point(1,1,1,3);
is($dist, 2);
is($dx, 0);
is($dy, 2);
is(Local::perlxs::distance_call_point(), 2);
is(Local::perlxs::distance_call_arg_point(), 2 );
my $point1 = {x => 1, y => 1};
my $point2 = {x => 1, y => 3};
is(Local::perlxs::distance_pointobj($point1, $point2), 2);
is(Local::perlxs::distance_pointstruct($point1, $point2), 2);
$point1->{z} = 1;
$point2->{z} = 1;
is(Local::perlxs::distance3d_pointstruct($point1, $point2), 2);

is(Local::perlxs::distance_call_point_2('Local::perlxs::get_points_2'), 5);
is(Local::perlxs::distance_call_arg_point_2('Local::perlxs::get_points_2'), 5 );
my $circle = {x => 1, y => 3, r => 1};
is(Local::perlxs::distance_circlestruct($point1, $circle), 1);
is_deeply(Local::perlxs::crosspoint_circlestruct($point1, $circle), {x=>1, y=>2});



#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

