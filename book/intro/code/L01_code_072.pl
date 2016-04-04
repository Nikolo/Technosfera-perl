\begin{minted}{perl}
# numbers
~0   # 0xffff_ffff or 0xffff_ffff_ffff_ffff
0777 & ~027 # 0750 (in oct)

# byte string
~"test"    # "\213\232\214\213"
# chr(~ord("t")).chr(~ord("e")).
# chr(~ord("s")).chr(~ord("t"));
# char string
use utf8;
"ё" # ≡ "\x{451}"
~"ё" # "\x{fffffbae}" 32b
~"ё" # "\x{fffffffffffffbae}" 64b
\end{minted}
