\begin{minted}{perl}
my @ary = (1,2,undef,7);
say "sparse" if undef ~~ @ary;

given ($num) {
when ([1,2,3]) { # as $num ~~ [1,2,3]
say "1..3";
}
when ([4..7]) {  # as $num ~~ [4..7]
say "4..7";
}
}
\end{minted}
