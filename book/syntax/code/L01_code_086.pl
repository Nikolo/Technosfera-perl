\begin{minted}{perl}
@a = 1..10;

for ("a".."z") {
say $_;
}

say "A"..."Z";

@b = @a[3..7];
\end{minted}
