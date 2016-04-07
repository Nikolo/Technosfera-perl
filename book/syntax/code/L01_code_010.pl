\begin{minted}{perl}
goto &NAME;
goto &$var;

sub fib {
	return 0 if $_[0] == 0;
	return 1 if $_[0] == 1;
	return _fib($_[0]-2,0,1);
}

sub _fib { my ($n,$x,$y) = @_;
	if ($n) {
		return _fib( $n-1, $y, $x+$y );
	}
	else {
		return $x+$y;
	}
}
\end{minted}
