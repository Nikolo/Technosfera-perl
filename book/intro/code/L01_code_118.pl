\begin{minted}{perl} 
chdir $foo    || die; # (chdir $foo) || die
chdir($foo)   || die; # (chdir $foo) || die
chdir ($foo)  || die; # (chdir $foo) || die
chdir +($foo) || die; # (chdir $foo) || die

rand 10 * 20;         # rand (10 * 20)
rand(10) * 20;        # (rand 10) * 20
rand (10) * 20;       # (rand 10) * 20
rand +(10) * 20;      # rand (10 * 20)

-e($file).".ext"      # -e( ($file).".ext" )
\end{minted}
