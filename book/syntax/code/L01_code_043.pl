\begin{minted}{perl}
sub mysub;
...
sub mysub {
@_;              # <- args here
my $a = shift;   # one arg
my ($a,$b) = @_; # 2 args
my %h = @_;      # kor k/v
say "my arg: ",$_[0];

return unless defined wantarray;
return (1,2,3) if wantarray; # return list
1; # implicit ret, last statement
}
\end{minted}
