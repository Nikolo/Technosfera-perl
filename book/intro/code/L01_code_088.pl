\begin{minted}{perl}
for $. (1..5) { print "$.";
	do {
		print "\tL,ret ".($.==2?"T":"F");
		$. == 2;
	} `..` do {
		print "\tR,ret ".($.==4?"T":"F");
		$. == 4;
	};
	say " : ".scalar(2..4);
}
\end{minted}
