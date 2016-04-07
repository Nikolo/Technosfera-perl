\begin{minted}{perl}
sub test1 {
	my $i=0;
	while ( ($pk, $f, $l,$s) = caller($i++)) {
		say "$i. from $f:$l ($s)";
	}
}
sub test2 {
	test1()
};
sub test3 {
	test2();
}
sub test4 { goto &test2; }
test3();
test4();
\end{minted}
