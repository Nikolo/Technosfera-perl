use 5.010;

sub decorator {
	my $decor = shift;
    return sub {
        return $decor."@_".$decor;
    }
}

my $dq = decorator "'";
my $dd = decorator '"';
my $ds = decorator '/';
say $dq->('test');
say $dd->('test');
say $ds->('test');
