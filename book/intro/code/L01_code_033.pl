\begin{minted}{perl}
$name = "var";
$$name = 1;     # устанавливает $var в 1
${$name} = 2;   # устанавливает $var в 2
@$name = (3,4); # устанавливает @var в (3,4)

$name->{key} = 7; # создаёт %var и
# устанавливает $var{key}=7

$name->();      # вызывает функцию var
\end{minted}
