$obj->A::get_a();

my $class = 'A';
$class->new();

my $method_name = $cond ? 'get_a' : 'get_b';
$obj->$method_name;

A::new();   # not the same!
