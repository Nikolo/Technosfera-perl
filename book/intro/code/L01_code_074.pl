\begin{minted}{perl}
return +{}; # empty anon hash
map { +{ $_ => -$_} } @_;
\end{minted}
