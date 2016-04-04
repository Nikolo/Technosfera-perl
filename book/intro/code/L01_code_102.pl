\begin{minted}{perl}
LOOP: {
	do {
		next if $cond1;
		redo if $cond2;
		...
	} while ( EXPR );
}
\end{minted}
