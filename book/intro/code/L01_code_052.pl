\begin{minted}{perl}
@squares = map { $_**2 } 1..5; # 1,4,9,16,25

say map chr($_), 32..127;

@nums = 1..100;
@sqrs = map {
	if( int(sqrt($_)) == sqrt($_) ) {
		$_
	} else { () }
} @nums;

my @reduced =
	map $_->[1],
	grep { int($_->[1]) == $_->[1] }
	map { [$_,sqrt $_] } 1..1000;
\end{minted}
