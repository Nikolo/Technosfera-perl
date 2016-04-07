\begin{minted}{perl}
use strict 'refs';

${ bareword }    # ≡ $bareword; # ok
${ "bareword" }; # not ok

$hash{ "key1" }{ "key2" }{ "key3" }; # ok
$hash{ key1 }{ key2 }{ key3 }; # also ok

$hash{shift}; # ok for keyword, no call
$hash{ +shift }; # call is done
$hash{ shift() }; # or so
\end{minted}
