\begin{minted}{perl}
(my $v = 5);
(
	my @a = (
		1, 2,
		sort(
			3,
			(4 + $v),
			(6 x 2),
			7
		)
	)
);
\end{minted}
