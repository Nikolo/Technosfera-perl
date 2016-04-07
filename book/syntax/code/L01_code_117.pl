\begin{minted}{perl} 
use feature 'signatures';
sub foo ($x, $y) {
return $x**2+$y;
}

sub foo {
die "Too many arguments for subroutine"
unless @_ <= 2;
die "Too few arguments for subroutine"
unless @_ >= 2;
my $x = $_[0];
my $y = $_[1];
return $x**2 + $y;
}
\end{minted}
