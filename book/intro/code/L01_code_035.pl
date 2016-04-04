\begin{minted}{perl}
$var = "one";
@ary = (3, "four", 5);
%hash = (k => "v", x => "y");
say "new $var";      # new one
say 'new $var';      # new $var

$" = ';'; # $LIST_SEPARATOR
say "new @ary";      # new 3;four;5
say 'new @ary';      # new @ary
say "1st: $ary[0]";  # 1st: 3
say "<@ary[1,2]>";   # <four;5>
say "<${ ary[1] }>"; # <four>
say "<$hash{x}>";    # <y>
\end{minted}
