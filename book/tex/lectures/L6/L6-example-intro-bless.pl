{
    package Class::Name;
    #...
}

my $obj = bless {}, 'Package::Name';

my $obj2 = bless [], '...';
my $scalar = 42;
my $obj2 = bless \$scalar, '...';
