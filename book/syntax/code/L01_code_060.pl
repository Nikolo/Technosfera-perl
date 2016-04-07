\begin{minted}{perl}
while (<>) {
	say int( log ( abs $_ ) / log 10 );
}

printf "%g\n", log ( 1e6 ) / log( 10 ) - 6 ;
# -8.88178e-16
\end{minted}
