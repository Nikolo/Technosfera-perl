\begin{minted}{perl}
_ # scalar or $_
+ # hash or array (or ref to)
\ # force type
\[%@] # ex: real hash or array

sub vararg($$;$); # 2 req, 1 opt
sub vararg($$;@); # 2 req, 0..* opt
sub noarg(); # no arguments at all
\end{minted}
