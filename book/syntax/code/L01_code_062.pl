\begin{minted}{perl}
say time;         # 1443632440
say ~~localtime;  # Wed Sep 30 20:00:40 2015
say ~~localtime 0;# Thu Jan  1 03:00:00 1970
say ~~gmtime 0;   # Thu Jan  1 00:00:00 1970

($s,$m,$h,$D,$M,$Y,$Wd,$Yd,$dst) =
localtime( time+86400 );
printf "%04u-%02u-%02uT%02u:%02u:%02u",
$Y+1900, $M+1, $D, $h, $m, $s;
printf "Day no: %u, Weekday: %u", $Yd, $Wd;

# 2015-10-01T20:00:40
# Day no: 273, Weekday: 4

use POSIX 'strftime';
say strftime "%r",localtime(); # 08:00:40 PM
\end{minted}
