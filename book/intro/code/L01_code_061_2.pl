\begin{minted}{perl}
@a = ( 1, 2, 3, 4, 5, 6, 7 );
#│        └────┬┘
#│        └─┐  │     ┌ replacement
#└──────┐   │  │  ┌──┴───┐
splice( @a, 1, 3, ( 8, 9 ) );
say @a;
# 1, 8, 9, 5, 6, 7
\end{minted}
