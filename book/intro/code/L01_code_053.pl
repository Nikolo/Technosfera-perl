\begin{minted}{perl}
@alphabetically = sort @strings;
@nums = sort { $a <=> $b } @numbers;
@reverse = sort { $b <=> $a } @numbers;
@ci = sort { fc($a) cmp fc($b) } @strings;

sub smart {$a<=>$b || fc($a) cmp fc($b) }
@sorted = sort smart @strings;

my @byval = sort { $h{$a} cmp $h{$b} } keys %h;
\end{minted}
