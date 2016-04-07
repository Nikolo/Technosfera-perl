\begin{minted}{perl}
open $file, "<", "0" || die "Can't";
open $file, "<", ( "0"||die "Can't" );
open $file, "<", "0" or die "Can't";
open ( $file, "<", "0" ) or die "Can't";

do_one() and do_two() or do_another();

@info = stat($file) || say "error";
#                    ^-cast scalar context
@info = stat($file) or say "error";
#                    ^-keep list context
\end{minted}
