\begin{minted}{perl} 
($a,$b) = $aref->@[ 1,3 ];
($a,$b) = @{ $aref }[ 1,3 ];

($a,$b) = $href->@{ "key1", "key2" };
($a,$b) = @{ $href }{ "key1","key2" };

%sub = $aref->%[ 1,3 ];
%sub = %{ $aref }[1,3];
%sub = (1 => $aref->[1], 3 => $aref->[3]);

%sub = $href->%{ "k1","k3" };
%sub = %{ $href }["k1","k3"];
%sub = (k1 => $href->{k1},
	k3 => $href->{k3});
\end{minted}
