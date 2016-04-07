\begin{minted}{perl}
goto EXPR; # DEPRECATED

{
EVEN:
	say "even";
	last;
ODD:
	say "odd";
	last;
}

goto(
	("EVEN","ODD")[ int(rand 10) % 2 ]
);
\end{minted}
