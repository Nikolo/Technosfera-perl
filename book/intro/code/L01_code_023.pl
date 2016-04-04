\begin{minted}{perl}
@simple = qw(1 2 3 bare);
@array = (4,8,15,16,23,42,@simple);
@array = (4,8,15,16,23,42,1,2,3,'bare');
$aref = \@array;
$aref = [4,8,15,16,23,42,@simple];

say $array[2];   # 15
say ${array}[2];
say ${array[2]};
say "last i = ", $#array;
say "last i = ", $#{array};

say $aref->[2];
say $$aref[2];
say ${$aref}[2];
say "last i = ", $#$aref;
say "last i = ", $#${aref};
say "last i = ", $#{${aref}};
\end{minted}
