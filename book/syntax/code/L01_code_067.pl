\begin{minted}{perl}
STMT->{...} # STMT должен вернуть HASHREF

STMT->[...] # STMT должен вернуть ARRAYREF

STMT->(...) # STMT должен вернуть CODEREF

STMT->method(...)
# STMT должен вернуть объект или класс
STMT->$var(...)
# $var должен вернуть имя метода или CODEREF
\end{minted}
