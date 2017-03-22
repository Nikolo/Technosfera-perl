use 5.010;
use Socket ':all';

my $host = 'search.cpan.org';

my $ip = gethostbyname $host;
say $ip;  # ����
say length $ip; # 4
say inet_ntoa $ip; # 194.106.223.155
say unpack "H*", $ip; # c26adf9b
say $ip eq inet_aton("194.106.223.155"); # 1
say join ".", unpack "C4", $ip; # 194.106.223.155
say unpack "N", $ip; # 3261783963

