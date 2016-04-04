\begin{minted}{perl}
for my $item ( @items ) {
	my $success = prepare($item);

	unless ($success) {
		last;
	}

	process($item);
} continue {
	postcheck($item);
}
# last переходит сюда
\end{minted}
