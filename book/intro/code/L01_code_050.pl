\begin{minted}{perl}
sub check (&@) {
	my ($code, @args) = @_;
	for (@args) {
		$code->($_);
	}
}

check {
	if( $_[0] > 10 ) {
		die "$_[0] is too big";
	}
} 1, 2, 3, 12;
\end{minted}
