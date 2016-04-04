\begin{minted}{perl}
$big = "WORD"; $small = "word";
say lc $big;         # word "\L"
say lcfirst $big;    # wORD "\l"
say uc $small;       # WORD "\U"
say ucfirst $small;  # Word "\u"

say "equal" if
fc $big eq fc $small; # v5.16+

say "\u\LnAmE\E"; # Name
\end{minted}
