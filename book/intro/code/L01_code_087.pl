\begin{minted}{perl}
for $. (1..5) { # $. - $INPUT_LINE_NUMBER
say "$. : ".(2..4);
}

1 :
2 : 1      # became true ($. == 2)
3 : 2      # stay true, while $. != 4
4 : 3E0    # ret true, $. == 5, became false
5 :
\end{minted}
