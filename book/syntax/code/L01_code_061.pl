\begin{minted}{perl}
%h = map { $_ => -$_ } 1..3;
@a = keys %h; @b = values %h;
while (my ($k,$v) = each @a)
	{ say "$k: $v ($b[$k])"; }
while (my ($k,$v) = each %h)
	{ say "$k: $v"; }
\end{minted}
