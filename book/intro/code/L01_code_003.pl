\begin{minted}{perl}
for my $item ( @items ) {
	my $success = prepare($item);

	unless ($success) {
		next;
	}

	process($item);
} continue {
	# next переходит сюда
	postcheck($item);
}
\end{minted}
