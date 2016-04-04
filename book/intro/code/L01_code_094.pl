\begin{minted}{perl}
say 'string';
say q{string};
say q/string/;
say q;string;;
say q{str{i}ng}; # balanced
say q qtestq;
say q{str{ing};  # not ok, unbalanced }
\end{minted}
