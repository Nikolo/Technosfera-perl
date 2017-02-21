my $u;

eval '
  $u = 5;
  my $y = 10;
  sub m_3 {
    my ($x) = @_;
    return $x * 3;
  }
';

$u;       # 5
$y;       # Undefined
m_3(2);   # 6
