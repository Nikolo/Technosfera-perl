\begin{minted}{perl}
#            \downarrow─────index($_," ") # 4
$_  =   "some average string\n";
#           └─┬─┘    ↑───rindex($_," ") # 12
#        substr($_,3,5) = "e ave"
\end{minted}