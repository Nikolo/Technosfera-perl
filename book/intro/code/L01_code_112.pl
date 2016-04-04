\begin{minted}{perl} 
LOOP: {
	do {{
		next if $cond1;
		redo if $cond2;
		last LOOP if $cond3;
		...
	}} while ( EXPR );
}
\end{minted}
