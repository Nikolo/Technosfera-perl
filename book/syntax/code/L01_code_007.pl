\begin{minted}{perl}
use feature 'switch'; # v5.10+

given ( EXPR ) {
	when ( undef )    { ... }
	when ( "str" )    { ... }
	when ( 42 )       { ... }
	when ( [4,8,15] ) { ... }
	when ( /regex/ )  { ... }
	when ( \&sub )    { ... }
	when ( $_ > 42 )  { ... }
	default           { ... }
}
\end{minted}
