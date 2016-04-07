\begin{minted}{perl}
{
	# redo
	stmt;
	if (...) { next; }

	stmt;
	if (...) { last; }

	stmt;
if (...) { redo; }

	stmt;
	# next
}
# last
\end{minted}
