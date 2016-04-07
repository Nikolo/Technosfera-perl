\begin{minted}{perl}
eval "syntax:invalid";
warn $@ if $@;

eval { $a/$b; };
warn $@ if $@;

eval { die "Not root" if $<; };
warn $@ if $@;

eval {      # try
	...;
1} or do {  # catch
	warn "Error: $@";
};
\end{minted}
