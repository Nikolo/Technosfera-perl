\begin{minted}{perl}
# match
$var =~ /regexp/;
$var !~ /shoudn't/;

# replace
$var =~ s/word/bare/g;

# transliterate
$var =~ tr/A-Z/a-z/;

if ($var = ~ /match/) {...} # always true
#         ^
#         '-------- beware of space
if ($var = (~(/match/))) {...}
\end{minted}
