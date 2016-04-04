\begin{minted}{perl}
$, = ", "; # $OUTPUT_FIELD_SEPARATOR
@array = (1,2,3);
say @array; # 1, 2, 3

@array = [1,2,3];
say @array; # ARRAY(0x7fcd02821d38)
\end{minted}
