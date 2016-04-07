\begin{minted}{perl}
-0       #  0
-1       # -1
- -1     #  1
-"123"   # -123
-"-123"  #  123
-undef   #  0 or -0
-bare    # "-bare"
-"word"  # "-word"
-"+word" # "-word"
-"-word" # "+word"
-"-0"    #  0 or +0
\end{minted}
