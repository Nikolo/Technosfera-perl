\begin{minted}{perl}
$, = ', ';

say qw(a b c);
# say split / /, 'a b c';

for (qw(/usr /var)) {
	say stat $_;
}
\end{minted}
