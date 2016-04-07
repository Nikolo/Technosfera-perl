\begin{minted}{perl}
goto &NAME;
goto &$var;

sub fac {
	my $n = shift;
	return _fac($n,1);
}

sub _fac {
	my ($n,$acc) = @_;
	return $acc if $n == 0;
	@_ = ($n-1,$n*$acc);
	goto &_fac;
}
\end{minted}
