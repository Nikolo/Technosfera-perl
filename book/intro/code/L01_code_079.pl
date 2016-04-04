\begin{minted}{perl}
say 20 << 20;  # 20971520
say 20 << 40;  # 5120 on 32-bit
	# 21990232555520 on 64-bit
use bigint;
say 20 << 80;  # 24178516392292583494123520
\end{minted}
