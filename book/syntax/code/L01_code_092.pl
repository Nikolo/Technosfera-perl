\begin{minted}{perl}
use constant CONST => "some";
%hash = ( CONST   => "val"); # "CONST"
%hash = (+CONST   => "val"); # "CONST"
%hash = ( CONST() => "val"); # "some"
%hash = (&CONST   => "val"); # "some"
\end{minted}
