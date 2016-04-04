\begin{minted}{perl}
for my $item ( @items ) {
	# redo переходит сюда
	my $success = prepare($item);

	unless ($success) {
		redo;
	}

	process($item);
} continue {
	postcheck($item);
}
\end{minted}
