use strict;
use warnings;

use Test::More tests => 3;
use Test::DBIx::Class;

my $student_rs  = Schema->resultset('Student');
my $teacher_rs  = Schema->resultset('Teacher');
my $grade_rs    = Schema->resultset('Grade');
my $homework_rs = Schema->resultset('Homework');

my $student1 = $student_rs->create({});
my $student2 = $student_rs->create({});

my $homework1 = $homework_rs->create({name => 'A', max_points => 10});
my $homework2 = $homework_rs->create({name => 'B', max_points => 6});

my $teacher = $teacher_rs->create({});

$grade_rs->create({
    homework => $homework1,
    student  => $student1,
    teacher  => $teacher,
    points   => 7,
});
$grade_rs->create({
    homework => $homework2,
    student  => $student1,
    teacher  => $teacher,
    points   => 5,
});
$grade_rs->create({
    homework => $homework1,
    student  => $student2,
    teacher  => $teacher,
    points   => 12,
});
$grade_rs->create({
    homework => $homework2,
    student  => $student2,
    teacher  => $teacher,
    points   => 6,
});

my @overscored_hw1 = $student1->search_overscored_homeworks()->all();
my @overscored_hw2 = $student2->search_overscored_homeworks()->all();

is(scalar @overscored_hw1, 0, 'no overscored homeworks');
is(scalar @overscored_hw2, 1, 'has overscored homeworks');
is($overscored_hw2[0]->name, 'A', 'oversocred homeworks');
