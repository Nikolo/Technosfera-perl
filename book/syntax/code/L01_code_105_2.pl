\begin{minted}{perl}
@array = (
"value1",
"value2",
"value3",
"value4",
);
#%sub = (
#    1 => $array[1],
#    3 => $array[3],
#);
 %sub = %array[ 1, 3 ];
#^     ^      ^
#|     +------+--- на массиве
#+----------------- хэш-срез
\end{minted}
