use 5.010;

say $scalar_ref = \$scalar;
say $array_ref  = \@array;
say $hash_ref   = \%hash;
say $code_ref   = \&function;
say $glob_ref   = \*FH;
say $ref_ref    = \$scalar_ref;
say $array_ref  = [ 4,8,15,16 ];
say $hash_ref   = { one => 1, two => 2 };
say $code_ref   = sub { ... };
($one,$two) = (\"one",\"two");
($one,$two) = \("one","two");