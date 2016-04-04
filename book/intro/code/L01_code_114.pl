\begin{minted}{perl} 
%hash = (
	key1 => "value1",
	key2 => "value2",
	key3 => "value3",
	key4 => "value4",
);
#%sub = (
#    key1 => $hash{key1},
#    key3 => $hash{key3},
#);
%sub = %hash{"key1","key3"};
			^    ^             ^
			|    +-------------+--- на хэше
			+----------------------- хэш-срез
\end{minted}
