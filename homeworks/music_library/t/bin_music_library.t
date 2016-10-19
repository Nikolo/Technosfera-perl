use strict;
use warnings;

use Test::More tests => 11;

sub test_bin {
    my ($name, $params, $input, $output) = @_;

    open(my $input_fh, '>', 'input.tmp');
    $input_fh->print($input);
    $input_fh->close();

    system("$^X bin/music_library.pl $params < input.tmp > output.tmp");

    my $real_output;
    {
        local $/ = undef;
        open(my $output_fh, '<', 'output.tmp');
        $real_output = <$output_fh>;
        $output_fh->close();
    }

    is($real_output, $output, $name);

    unlink('input.tmp');
    unlink('output.tmp');
}

test_bin
'basic', '',
<<INPUT
./Band/123 - Album/track.mp3
./B/3210 - AlbumAlbum/t.format
INPUT
,
<<OUTPUT
/-------------------------------------------\\
| Band |  123 |      Album | track |    mp3 |
|------+------+------------+-------+--------|
|    B | 3210 | AlbumAlbum |     t | format |
\\-------------------------------------------/
OUTPUT
;

test_bin
'no rows', '--band UNKNOWN',
<<INPUT
./B/3210 - AlbumAlbum/x.format
INPUT
,
<<OUTPUT
OUTPUT
;

test_bin
'filter', '--band B',
<<INPUT
./Band/123 - Album/track.mp3
./B/3210 - AlbumAlbum/t.format
./B/3210 - AlbumAlbum/x.format
INPUT
,
<<OUTPUT
/------------------------------------\\
| B | 3210 | AlbumAlbum | t | format |
|---+------+------------+---+--------|
| B | 3210 | AlbumAlbum | x | format |
\\------------------------------------/
OUTPUT
;

test_bin
'int filter', '--year 210',
<<INPUT
./B/0210 - AlbumAlbum/t.format
./B/210 - AlbumAlbum/x.format
./B/310 - AlbumAlbum/x.format
INPUT
,
<<OUTPUT
/------------------------------------\\
| B | 0210 | AlbumAlbum | t | format |
|---+------+------------+---+--------|
| B |  210 | AlbumAlbum | x | format |
\\------------------------------------/
OUTPUT
;

test_bin
'sort', '--sort format',
<<INPUT
./B/210 - AlbumAlbum/m.mp3
./B/210 - AlbumAlbum/o.ogg
./B/210 - AlbumAlbum/a.abc
INPUT
,
<<OUTPUT
/--------------------------------\\
| B | 210 | AlbumAlbum | a | abc |
|---+-----+------------+---+-----|
| B | 210 | AlbumAlbum | m | mp3 |
|---+-----+------------+---+-----|
| B | 210 | AlbumAlbum | o | ogg |
\\--------------------------------/
OUTPUT
;

test_bin
'int sort', '--sort year',
<<INPUT
./B/10 - AlbumAlbum/m.mp3
./B/100 - AlbumAlbum/o.ogg
./B/20 - AlbumAlbum/a.abc
INPUT
,
<<OUTPUT
/--------------------------------\\
| B |  10 | AlbumAlbum | m | mp3 |
|---+-----+------------+---+-----|
| B |  20 | AlbumAlbum | a | abc |
|---+-----+------------+---+-----|
| B | 100 | AlbumAlbum | o | ogg |
\\--------------------------------/
OUTPUT
;

test_bin
'columns', '--columns year,band,year',
<<INPUT
./B/1 - A/m.mp3
./B/2 - B/o.ogg
./B/3 - C/a.abc
INPUT
,
<<OUTPUT
/-----------\\
| 1 | B | 1 |
|---+---+---|
| 2 | B | 2 |
|---+---+---|
| 3 | B | 3 |
\\-----------/
OUTPUT
;

test_bin
'no columns', q{--columns ''},
<<INPUT
./B/1 - A/m.mp3
./B/2 - B/o.ogg
./B/3 - C/a.abc
INPUT
,
<<OUTPUT
OUTPUT
;
test_bin
'more print filters', '--band B --year 12',
<<INPUT
./B/1 - A/m.mp3
./A/12 - B/t.flac
./B/012 - AB/s.ogg
./B/12 - B/o.ogg
./A/12 - A/A.A
./B/3 - C/a.abc
INPUT
,
<<OUTPUT
/------------------------\\
| B | 012 | AB | s | ogg |
|---+-----+----+---+-----|
| B |  12 |  B | o | ogg |
\\------------------------/
OUTPUT
;

test_bin
'more print filters and columns', '--band B --year 12 --columns year,band,band,track,album,band,year',
<<INPUT
./B/1 - AA/music.mp3
./B/12 - BA/track.flac
./B/012 - AB/song.ogg
./B/13 - AB/song.ogg
./A/12 - BQ/song.mp3
./B/12 - BB/o.ogg
./A/12 - AC/A.A
./B/3 - CQ/a.abc
INPUT
,
<<OUTPUT
/------------------------------------\\
|  12 | B | B | track | BA | B |  12 |
|-----+---+---+-------+----+---+-----|
| 012 | B | B |  song | AB | B | 012 |
|-----+---+---+-------+----+---+-----|
|  12 | B | B |     o | BB | B |  12 |
\\------------------------------------/
OUTPUT
;

test_bin
'more print filters and columns and sort', '--sort album --band B --year 12 --columns year,band,band,album,band,year',
<<INPUT
./B/1 - AA/music.mp3
./B/12 - BA/track.flac
./B/012 - AB/song.ogg
./B/13 - AB/song.ogg
./A/12 - BQ/song.mp3
./B/12 - BB/o.ogg
./A/12 - AC/A.A
./B/3 - CQ/a.abc
INPUT
,
<<OUTPUT
/----------------------------\\
| 012 | B | B | AB | B | 012 |
|-----+---+---+----+---+-----|
|  12 | B | B | BA | B |  12 |
|-----+---+---+----+---+-----|
|  12 | B | B | BB | B |  12 |
\\----------------------------/
OUTPUT
;
