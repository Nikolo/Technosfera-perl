\begin{minted}{perl}
goto LABEL;

LABEL1:
	say "state 1";
	goto LABEL2;
LABEL2:
	say "state 2";
	goto LABEL1;

state 1
state 2
state 1
state 2
...
\end{minted}
