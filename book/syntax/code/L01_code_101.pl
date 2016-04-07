\begin{minted}{perl}
do {{
	next if $cond1;
	redo if $cond2;
	...
}} while ( EXPR );
\end{minted}
