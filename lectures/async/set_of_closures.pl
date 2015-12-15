use 5.010;

my @subs;
for my $var (1..10) {
    my $sub = sub {
        return $var + $_[0];
    };
    push @subs, $sub;
}

say join " ", map $_->(2), @subs;
for my $sub (@subs) {
    say $sub->(2); # 
}

say join " ", map $_->(10), @subs;
for my $sub (@subs) {
    say $sub->(10); # 
}
