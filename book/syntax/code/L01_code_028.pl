\begin{minted}{perl}
$var = 7;
%hash = (
	s => "string",
	a => [ qw(some elements) ],
	h => {
		nested => "value",
		"key\0" => [ 1,2,$var ],
	},
	f => sub { say "ok:@_"; },
);

say $hash{s}; # string
say $hash{a}->[1]; # elements
say $hash{h}->{"key\0"}->[2]; # 7
say $hash{h}{"key\0"}[2]; # 7
$hash{f}->(3); # ok:3
&{ $hash{f} }(3); # ok:3

\end{minted}
