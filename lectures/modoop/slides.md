class: firstpage title

# Программирование на Perl

## Модули и ООП

---

class:note_and_mark title

# Отметьтесь на портале!

---

# Модули: разделяй и властвуй

* Структурирование кода
    * читабельность
    * надежность
* Повторное использование кода
    * в рамках проекта
    * за пределами проекта
* Совместная работа над проектом

---

# Модули: как разделять

* Низкий уровень
    * Работа с внешней подсистемой
        * база данных
        * сеть
        * xml-файлы
    * Специфические вычисления
        * работа с большими числами
        * работа датами и временем
        * шифрование
* Высокий уровень
    * функционал для регистрации и авторизации пользователей
    * функционал для загрузки, отображения и обработки фото на сайте

---

# Модули: как властвовать

* Расположение кода в отдельных файлах
    * `eval`
    * `do`
    * `require`
    * `use`
* Пространства имен и области видимости
    * пакеты
    * области видимости
* Модули
    * версионность
    * pragma
    * CPAN

---

# Функция `eval`

* видит переменные, объявленные снаружи
* имеет свою область видимости
* возвращает последнее вычисленное значение
* возвращает `undef` и устанавливает `$@` в случае ошибки компиляции/выполнения

--

.small[
```perl
my $E = 2.72;

my `$code` = <<'CODE';
    warn "Loading...\n";
    sub pow { $_[0] ** $_[1]; }
    $E = 2.71828183;
    my $PI = 3.14159265;
CODE

say "eval=", `eval $code`; # eval=3.14159265

say "pow(2,8)=",pow(2,8);  # pow(2,8)=256
say "E=$E";                # E=2.71828183
say "PI=$PI";              # PI=undef
```
]

---

# Функция `do`

* видит переменные, объявленные снаружи
* имеет свою область видимости
* возвращает последнее вычисленное значение
* возвращает `undef` и устанавливает `$!` в случае ошибки открытия файла
* возвращает `undef` и устанавливает `$@` в случае ошибки компиляции/выполнения

--

.small[
```perl
# Local/Math.pm
warn "Loading...\n";
sub pow { $_[0] ** $_[1]; }
$E = 2.71828183;
my $PI = 3.14159265;
```
]
--
.small[
```perl
say 'do=', `do "Local/Math.pm"`; # Loading...
                                 # do=3.14159265
say '$@=', $@;                   # $@=undef
say '$!=', $!;                   # $!=undef
say 'pow(2,8)=', pow(2,8);       # pow(2,8)=256
```
]

---

# Функция `do`

## Список директорий для поиска модулей @INC

```bash
*$ perl -e 'print join "\n", @INC' | head –3
/usr/local/lib64/perl5
/usr/local/share/perl5
/usr/lib64/perl5/vendor_perl
```

```bash
$ `PERL5LIB=/home/www/lib` \
>     perl -e 'print join "\n", @INC' | head -2
/home/www/lib
/usr/local/lib64/perl5
```

```bash
$ perl `-I/home/www/lib` \
>     -e 'print join "\n", @INC' | head -2
/home/www/lib
/usr/local/lib64/perl5
```

---

# Функция `require`

* останавливает выполнение в случае ошибки открытия файла, компиляции или выполнения
* не пытается загрузить и выполнить файл, если он уже был загружен ранее
* проверяет последнее вычисленное значение, останавливает выполнение, если оно ложно
* при первой загрузке файла возвращает последнее вычисленное значение, при последующих попытках его загрузить возвращает 1

--

.small[
```perl
$E = 2.72;
                               # Loading...
`require "Local/Math.pm"`;       # 3.14159265
say "E=$E";                    # E=2.71828183

$E = 2.72;
`require "Local/Math.pm"`;       # 1
say "E=$E";                    # E=2.72
```
]

---

# Функция `require`
## Список загруженных модулей %INC

```perl
say $INC{"Local/Math.pm"};     # undef

                               # Loading...
require "Local/Math.pm";       # 3.14159265

say $INC{"Local/Math.pm"};     # Local/Math.pm
```

---

# Пакеты

```perl
#Some/Module.pm
sub some_function { say "Some function call" }

#Another/Module.pm
sub some_function { say "Another function call" }
```
--
```perl
require "Some/Module.pm";
some_function();

require "Another/Module.pm";
some_function();                # WTF?!
```

---

# Пакеты

```perl
#Some/Module.pm
`package Some::Module`;
sub some_function { say "Some function call" }

#Another/Module.pm
`package Another::Module`;
sub some_function { say "Another function call" }
```
--
```perl
require "Some/Module.pm";
`Some::Module::`some_function();          # fqn

require "Another/Module.pm";
`Another::Module::`some_function();       # fqn
```

---

# Пакеты

```perl
package Local::Math;
# ...
package Local::Math::Integer;
# ...
# ...
# end of file
```

```perl
{
   package Local::Math;
   # ...
}
```

```perl
package Local::Math {
   # ...
}
```

---

# Пакеты

.small[
```perl
`package Local::Math`;
$PI = 3.14;
sub pow  { $_[0] ** $_[1] }

`package main`;
say "pow(2,2)=", `Local::Math::`pow(2,2);  # sqr(4)=2
say "fqn PI=",   `$Local::Math::`PI;       # fqn PI=3.14
say "PI=$PI";                              # PI=undef

`$Local::Math::`E = 2.72;
sub `Local::Math::`sqr {
    Local::Math::pow($_[0], 0.5)
}

say "sqr(4)=", Local::Math::sqr(4);  # sqr(4)=2
say "fqn E=",  $Local::Math::E;      # fqn E=2.72
say "E=$E";                          # E=undef

```
]

---

# Пакеты
## \_\_PACKAGE\_\_, \_\_FILE\_\_, \_\_LINE\_\_

```perl
# Local/Math.pm
package Local::Math;
sub pow  { $_[0] ** $_[1] }

printf "Pkg %s, file %s, line %d\n",
    `__PACKAGE__`, `__FILE__`, `__LINE__`;           
# Pkg `Local::Math`, file `Local/Math.pm`, line `4`

1;
```

--

```perl
# script.pl
require "Local/Math.pm";

printf "Pkg %s, file %s, line %d\n",
    `__PACKAGE__`, `__FILE__`, `__LINE__`;
# Pkg `main`, file `script.pl`, line `3`
```

---

# Функция `require`

.small[
```perl
require "/home/www/lib/Local/Math.pm";
require "Local/Math.pm";
require `Local::Math`;                 # BAREWORD!
```
]
--
.small[
```perl
#Local/Math.pm
package Local::Math;
...
package Local::Math::Int;
...
1;

#script.pl
require Local::Math;       # OK
require Local::Math::Int;  # Can't locate Local/Math/Int.pm in @INC 
```
]
---

# Функция `use`

```perl
use Local::Math;   # BAREWORD
```
--

```perl
BEGIN { 
    require Local::Math; 
    #and something else ;)
}

BEGIN { print Local::Math::pow(2, 8) } # 256
```

```perl
require Local::Math;

BEGIN { print Local::Math::pow(2, 8) }
# Undefined subroutine &Local::Math::pow
```

---

# Области видимости
## Пакетные переменные `our`

.small[
```perl
#Local/Math.pm
package Local::Math;
`our $PI` = 3.14159265;

package Local::Math::Float;

say $PI;                      # 3.14159265
say $Local::Math::Float::PI;  # undef
say $Local::Math::PI;         # 3.14159265

1;
```
]
--
.small[
```perl
#script.pl 
use Local::Math;

say $PI;                      # undef
say $Local::Math::PI;         # 3.14159265
```
]

---

# Области видимости
## Локальные переменные `my`

```perl
#Local/Module.pm
package Local::Module;

`my $x` = 4;
if($x == 4) {
    `my $x` = 5;
    say $x;     # 5
}
say $x;         # 4

1;
```
--
```perl
#script.pl
use Local::Module;

say $Local::Module::x;  # undef

```

---

# Области видимости
## Статические локальные переменные `state`

```perl
`use feature 'state'`;

sub test {
    `state $x` = 42;
    return $x++;
}

printf(                            # 42 43 44 45 46
    '%d %d %d %d %d',
    test(),test(),test(),test(),test()
);

say $x;                            # undef
```

---

# Области видимости
## Локализация значения пакетных переменных `local`

```perl
our $x = 10;
our %y = (x => 20, y => 30);
{
    `local $x` = -10;
    `local $y{x}` = -20;
    say $x;                # -10
    say $y{x};             # -20
}
say $x;                    #  10
say $y{x};                 #  20
```

---

# Области видимости
## Локализация значения специальных переменных `local`

```perl
# 1,2,3\n
my @lines = ();
{
    `local $/` = ",";
    while(<>) {
        push @lines, $_;         # "1," "2," "3\n"
    }
    chomp $lines[1];             # "2"
}
chomp $lines[0];                 # "1,"
chomp $lines[2];                 # "3"

{
    `local $/`;
    my $all = <>;                   # "1,2,3\n"
}
```

---

# Функция `use`
## Функция `import`

.small[
```perl
use Some::Module;

BEGIN {
    require Some::Module;
    `Some::Module::import`("Some::Module"); # if can
}
```
]

.small[
```perl
use Some::Module `('arg1', 'arg2')`;

BEGIN {
    require Some::Module;
    Some::Module::import(                 # if can
        "Some::Module",
        `'arg1', 'arg2'`
    );
}
```
]

---

# Функция `no`
## Функция `unimport`

.small[
```perl
`no Some::Module`;

BEGIN {
    require Some::Module;
    `Some::Module::unimport`("Some::Module");
}
```
]

.small[
```perl
no Some::Module `('arg1', 'arg2')`;

BEGIN {
    require Some::Module;
    Some::Module::unimport(
        "Some::Module",
        `'arg1', 'arg2'`
    );
}
```
]

---

# Функция `use`
## Подавление вызова `import`

```perl
use Some::Module `()`;

BEGIN {
    require Some::Module;
    # no func import call!
}
```
--
```perl
no Some::Module `()`;

BEGIN {
    require Some::Module;
    # no func unimport call!
}
```

---

# Функция `use`
## Версия модуля

```perl
# Local/Math.pm
package Local::Math;
`our $VERSION = 1.25`;

`package Local::Math::Int 1.22`;

say $Local::Math::VERSION;     # 1.25
say $Local::Math::Int::VERSION # 1.22
```

--

```perl
# main.pl
use Local::Math `1.26`;
# Local::Math version 1.26 required--this is
#     only version 1.25
```

---

# Функция `use`
## Версия модуля

```perl
package Local::Math;
our $VERSION = `v1.25.01`;
print $Local::Math::VERSION;  # ???
```

```perl
print v67.97.109.101.108.33;  # Camel!
```

```perl
package Local::Math `v1.25.01`;
print $Local::Math::VERSION;  # v1.25.01
```

```perl
use Local::Math v1.26.2;
# Local::Math version v1.26.2 required--this is
#     only version v1.25.1
```

---

# Функция `use`
## Версия perl

```perl
use `5.20`;
# Perl v5.200.0 required (did you mean v5.20.0?)--
#     this is only v5.16.3, stopped
```

```perl
use `v5.20`;
# Perl v5.20.0 required--this
# is only v5.16.3, stopped
```

```perl
use `5.020_000`;
# Perl v5.20.0 required--this
# is only v5.16.3, stopped
```

---

# Стандартные модули

* Модули
* Прагмы

См. [`perlmodlib`](http://perldoc.perl.org/perlmodlib.html)

---

# Стандартные модули

## Модуль `Exporter`

```perl
 package Local::Math;

 use Exporter qw/import/;
 our @EXPORT_OK = qw/$PI pow sqr/;
 our %EXPORT_TAGS = (
     func  => [ qw/pow sqr/ ],
     const => [ qw/$PI $E/  ],
 );
 our @EXPORT = qw/$PI/;

 our $PI = 3.14159265;
 our $E = 2.71828183;
 sub pow  { $_[0] ** $_[1]  }
 sub sqr  { pow($_[0], 0.5) }
```

---

# Стандартные модули

## Модуль `Exporter`

```perl
use Local::Math ();                 # nothing
use Local::Math;                    # $PI
use Local::Math qw/$PI/;            # $PI
use Local::Math qw/pow/;            # pow
use Local::Math qw/:const pow/;     # $PI $E pow
use Local::Math qw/:const &sqr/;    # $PI $E sqr
```
--
```perl
# without full qualified name
say $PI;       # 3.14159265
say sqr(4);    # 2 
```

---

# Стандартные модули

## Модуль `Getopt::Long`

```perl
use Getopt::Long;
use Data::Dumper;
GetOptions(
    'format=s' => \$format,
    verbose => \$verbose,
);
print Dumper [$format, $verbose];
```

```perl
# ./script.pl --format xml --verbose
$VAR1 = [
          'xml',
          1
        ];
```

---

# Стандартные модули

## Модуль `Getopt::Long`

```perl
my $CONFIG = {
    format => 'json',
    verbose => 0,
};
GetOptions(`$CONFIG`, qw/
    format=s
    verbose
/);
print Dumper($CONFIG);
```

```perl
# ./script.pl --format xml
$VAR1 = {
    format => 'xml',
    verbose => 0
};
```

---

# Стандартные модули

## Модуль `POSIX`

```perl
use POSIX ();
```

```perl
say POSIX::ceil(2.72);             # 3
say POSIX::floor(2.72);            # 2
```

```perl
say POSIX::strftime("%Y-%m-%d %T / %B",
    localtime(0));
# 1970-01-01 03:00:00 / January

use POSIX qw(setlocale LC_ALL);
setlocale(LC_ALL, "ru_RU.UTF-8");

say POSIX::strftime("%Y-%m-%d %T / %B",
    localtime(0));
# 1970-01-01 03:00:00 / Январь
```

---

# Стандартные модули
## Модуль `Time::Local`

.small[
```perl
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                                    `localtime`(time);
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                                    `gmtime`(time);
```
]
--
.small[
```perl
use Time::Local;
$time = `timelocal`($sec, $min, $hour, $mday, $mon, $year);
$time = `timegm`($sec, $min, $hour, $mday, $mon, $year);
```
]

---

# Стандартные модули
## Модуль `List::Util`
```perl
use List::Util qw/any all first max sum reduce/;

my @list  = (1, 2, 3, 4, 5);
my $bool  = any    { $_ > 4 }  @list;   # true
my $bool  = all    { $_ > 0 }  @list;   # true
my $first = first  { $_ > 3 }  @list;   # 4
my $max   = max                @list;   # 5
my $sum   = sum                @list;   # 15
my $prod  = reduce { $a * $b } @list;   # 120

```
---

# Прагмы

## Модуль `strict`

```perl
`use strict 'vars'`;

`our` $foo = 1;                  # ok
`my`  $bar = 2;                  # ok
$baz = 3;
# Global symbol "$baz" requires
#     explicit package name
```

---

# Прагмы

## Модуль `strict`

```perl
$foo = "bar";
$ref = "foo";
print $$ref;                   # bar
```
--
```perl
`use strict 'refs'`;
$foo = "bar";
$ref = "foo";
print $$ref;
# Can't use string ("foo") as a SCALAR ref
#     while "strict refs" in use
```

---

# Прагмы

## Модуль `strict`

```perl
$x = foo;
say $x;             # foo

sub foo { "bar" }
$x = foo;
say $x;             # bar
```
--
```perl
`use strict 'subs'`;
$x = foo;
# Bareword "foo" not allowed
#     while "strict subs" in use
```

---

# Прагмы

## Модуль `strict`

```perl
use strict;                   # qw/vars refs subs/
our $var = "foo";
my $ref = "var";
`{`
    `no strict 'refs'`;
    print $$ref;              # foo
`}`
print $$ref;
# Can't use string ("var") as a SCALAR ref
#     while "strict refs" in use
```

---

# Прагмы

## Модуль `vars`

```perl
use strict;

package Some::Package;
`use vars qw/$foo @bar/`;
$foo = 1;                     # ok
print $foo;                   # 1

package main;
print $foo;
# Global symbol "$foo" requires
#     explicit package name
```

---

# Прагмы

## Модуль `warnings`

```perl
`use warnings`;
`use warnings 'deprecated'`;

print "foo" . undef;                 # foo
# Use of uninitialized value in concatenation (.)
#     or string

`no warnings 'uninitialized'`;
print "foo" . undef;                 # foo
```

```bash
$ perl -`w`e 'print 5 + "a"'           # 5
# Argument "a" isn't numeric in addition (+)
```

---

# Прагмы

## Модуль `diagnostics`

```perl
`use diagnostics`;

print 5+"a";                      # 5
# Argument "a" isn't numeric in addition (+)
#     (W numeric) The indicated string was fed as
#     an argument to an operator that expected
#     a numeric value instead.  If you're fortunate
#     the message will identify which operator was
#     so unfortunate.
```

---

# Прагмы

## Модуль `lib`

```perl
`use lib qw(/home/www/lib /home/www/lib2)`;
```

```perl
BEGIN {
    unshift @INC,
    '/home/www/lib',
    '/home/www/lib2'
}
```

---

# Прагмы

## Модуль `feature`

```perl
`use feature qw/say state/`;     # a lot of features
`use feature ":5.10"`;           # features for 5.10
`use 5.10`;                      # features for 5.10

say 'New line follows this';

state $x = 10;
```

---

# Прагмы

## Модуль `constant`

```perl
`use constant PI => 3.14159265`;
# sub PI () { 3.14159265 }

print PI;                      # 3.14159265
# print 3.14159265;
```

```perl
use constant {
    PI => 3.14159265,
    E  => 2.71828183,
};
```

---

# CPAN

## Comprehensive Perl Archive Network

* DBI, DBD::mysql, DBD::Pg, DBD::SQLite
* Digest::SHA, Digest::MD5, Digest::SipHash
* Crypt::RSA, Crypt::Rijndael
* XML::Parser, XML::LibXML, YAML, JSON::XS
* LWP, Net::Twitter, Net::SMTP
* Devel::StackTrace, Devel::NYTProf
* Archive::Zip, MP3::Info, Image::ExifTool, GD

---

# Список литературы

* [`perlmod`](http://perldoc.perl.org/perlmod.html)
* [`perlsub`](http://perldoc.perl.org/perlsub.html)
* [`perlvar`](http://perldoc.perl.org/perlvar.html)
* [`perlfunc`](http://perldoc.perl.org/perlfunc.html)
* [`perlpragma`](http://perldoc.perl.org/perlpragma.html)
* [`perlmodlib`](http://perldoc.perl.org/perlmodlib.html)
* [`cpan`](http://perldoc.perl.org/cpan.html)
* [`perlnewmod`](http://perldoc.perl.org/perlnewmod.html)
* [`perlmodstyle`](http://perldoc.perl.org/perlmodstyle.html)
