\begin{minted}{perl}
$a = sprintf"%c %s %d %u\n%o %x %e %f %g",
9786, "str", -42, -1, 2537,
57005, 1/9, 1/3, .6626E-33;
say $a;
# ☺ str -42 18446744073709551615
# 4751 dead 1.111111e-01 0.333333 6.626e-34
\end{minted}
