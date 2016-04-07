\begin{minted}{perl}
use utf8; use open qw(:utf8 :std);
say chr(80);         # P
say ord("P");        # 80
say ord(chr(-1));    # 65533, BOM \x{fffd}
say ord("±");        # 177
say chr(177);        # ±
say chr(9786);       # ☺
say ord "ё";         # 1105
say hex "dead_beaf"; # 3735928495
say hex "0xDEAD";    # 57005
say oct "04751";     # 2537
\end{minted}
