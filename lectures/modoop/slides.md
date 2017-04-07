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
    sub pi { $PI }
CODE

say "eval=", `eval $code`; # eval=3.14159265

say "pow(2,8)=",pow(2,8);  # pow(2,8)=256
say "E=$E";                # E=2.71828183
say "PI=$PI";              # PI=undef
say "PI=",pi();            # PI=3.14159265
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

---

# Пишем модуль

## Задача: написать скрипт, выполняющий аутентификацию пользователя по его email и паролю
* для аутентифицированных пользователей должно выводиться персонифицированное приветствие, код возврата скрипта - 0
* в остальных случаях выдавать сообщение об ошибке, код возврата скрипта - любой, кроме 0
* всю обработку, связанную с пользовательскими данными, выделить в отдельный модуль
* база данных пользователей должна храниться в том же модуле (мы еще не умеем ходить в настоящие базы данных)

---

# Пишем модуль

```perl
#!/usr/bin/perl
use strict;
use feature 'say';
use Local::User;

my ($email, $passwd) = @ARGV;
die "USAGE: $0 <email> <password>\n“
    unless length $email && length $passwd;

my $user = get_by_email($email);
die "Пользователь с адресом '$email' не найден\n"
    unless $user;
die "Введен неправильный пароль\n"
    unless $user->{passwd} eq $passwd;

say welcome_string($user);
say 'Добро пожаловать';
```

---

# Пишем модуль

```perl
package Local::User 1.1;

use strict;
use warnings;

use List::Util qw/first/;
use Exporter 'import';

our @EXPORT = qw/get_by_email name welcome_string/;
```

---

# Пишем модуль

```perl
my @USERS = (
    {
        first_name => 'Василий',
        last_name  => 'Пупкин',
        gender => 'm',
        email => 'vasily@pupkin.ru',
        passwd => '12345',
    },
    {
        first_name => 'Николай',
        middle_name => 'Петрович',
        last_name  => 'Табуреткин',
        gender => 'm',
        email => 'taburet.98@mail.ru',
        passwd => 'admin',
    },
);
```

---

# Пишем модуль

```perl
# `first` imported from List::Util

sub get_by_email {
  my $email = shift;
  my $user =
    first { $_->{email} eq $email } @USERS;
  return $user;
}
```

---

# Пишем модуль

```perl
sub name {
  my $user = shift;
  return join ' ',
    grep { length $_ }
      map { $user->{$_} }
        qw/first_name middle_name last_name/;
}
```

---

# Пишем модуль

```perl
sub welcome_string {
  my $user = shift;
  return
    (
      $user->{gender} eq 'm' ?
      "Уважаемый " : "Уважаемая "
    ) . name($user) . "!";
}
```

---

# Пишем модуль

```perl
# :-)

1;
```

---

# Пишем модуль

```bash
$ perl auth
USAGE: auth <email> <password>
```

```bash
$ perl auth mike@mail.ru 123
Пользователь с адресом 'mike@mail.ru' не найден
```

```bash
$ perl auth taburet.98@mail.ru 12345
Введен неправильный пароль
```

```bash
$ perl auth taburet.98@mail.ru admin
Уважаемый Николай Петрович Табуреткин!
Добро пожаловать
```

---

# Пишем модуль

## Задача: изменить скрипт и модуль так, чтобы пароли не хранились в открытом виде

* использовать хеширование паролей
* использовать секретный ключ ("соль")

---

# Пишем модуль

```perl
package Local::User 1.2;
# ...
# not strong enough :-(
use Digest::MD5 'md5_hex';
# ...
my @USERS = (
  {
    first_name => 'Василий',
    last_name  => 'Пупкин',
    gender => 'm',
    email => 'vasily@pupkin.ru',
    passwd => 'd19f77fefeae0fabdfc75f17abc47c96',
  },
  # ...
);
```

---

# Пишем модуль

```perl
our @EXPORT = qw/
  get_by_email name welcome_string
  is_password_valid
/;
# ...
{
  my $SALT = "perl rulez!";

  sub is_password_valid {
    my ($user, $passwd) = @_;
    return
      $user->{passwd} eq md5_hex($passwd.$SALT);
  }
}
```

---

# Пишем модуль

```perl
#!/usr/bin/perl

use Local::User 1.2;

# ...

die "Введен неправильный пароль\n"
    unless is_password_valid($user, $passwd);

# ...
```

---

# Пишем модуль

## Задача: усовершенствовать механизм хранения и проверки паролей

* использовать дополнительный случайный ключ для усложнения подбора пароля по хешу
* предусмотреть возможное изменение механизма проверки пароля в будущем
* оставить обратную совместимость с форматом хранения паролей из версии 1.2

---

# Пишем модуль

```perl
package Local::User 1.3;
# ...
my @USERS = (
  {
    first_name => 'Василий',
    last_name  => 'Пупкин',
    gender => 'm',
    email => 'vasily@pupkin.ru',
    passwd =>
      '$1$f^34d*$24cc1e0d198dbf6bbfd812a30f1b4460',
  },
  # ...
);
```

---

# Пишем модуль

```perl
sub is_password_valid {
  my ($user, $passwd) = @_;

  my ($version, $data) = (0, $user->{passwd});
  if ($user->{passwd} =~ /^\$(\d+)\$(.+)$/) {
    # new scheme
    ($version, $data) = ($1, $2);
    die "Don't know passwd version $version"
      unless $CHECKERS{$version};
  }
  return $CHECKERS{$version}->($data, $passwd);
}
```

---

# Пишем модуль

```perl
# (password_hashed_data, password_to_check)
my %CHECKERS = (
  0 => sub { $_[0] eq md5_hex($_[1] . $SALT) },
  1 => sub {
    my ($rand, $hash) = split '$', $_[0];
    return
      $hash eq md5_hex($_[1] . $SALT . $rand);
  },
);
```

---

# ООП

1. Немного теории
    * сравнение процедурного и объектно-ориентированного подходов
    * основные понятия и определения из мира ООП
    * особенности реализации ООП в perl
1. Базовый синтаксис для ООП в perl
    * конструкторы и деструкторы
    * методы класса и методы объекта
    * аксессоры
    * наследование и композиция объектов
1. Примеры применения ООП в perl
1. Паттерны проектирования

---

# Процедурный код

## Программирование на императивном языке, при котором последовательно выполняемые операторы можно собрать в подпрограммы, то есть более крупные целостные единицы кода, с помощью механизмов самого языка

* центр внимания - исполняемый код, функции и их цепочки
* *`действия` производятся над `данными`*
* есть фиксированный набор функций, им на вход подают различные наборы данных
* высокая производительность - цепочки команд языка напрямую отражаются в низкоуровневые последовательности команд процессора
* крупные проекты трудно проектировать, так как мозг - не процессор

---

# Процедурный код

## Аналогии реального мира

* `Конвейер`: детали двигаются по конвейеру и на каждом этапе над ними производятся действия. Конвейер, как набор функций, неизменен, детали-данные меняются.
```perl
foreach my $component (@components) {
        foreach my $tool (@tools) {
            &$tool($component);
        }
}
```
* `Хлебопечка`: засыпаем муку, молоко и другие ингридиенты (входные данные), закрываем крышку (запускаем функцию), через некоторое время получаем на выходе хлеб.
Муку можно засыпать вручную, а можно соединить вход хлебопечки с выходом мельнички для зерна, и т. д.
```perl
$bread=breadmaker($milk, $eggs, mill($grains));
```
---

# ООП

##  Методология программирования, основанная на представлении программы в виде совокупности `объектов`, каждый из которых является экземпляром определенного `класса`, а классы образуют иерархию наследования

* центр внимания - `объект` (данные и набор функций для работы с ними) и взаимодействие `объектов`
* есть фиксированный набор типов объектов (`классы`), которые описывают свойства `объектов` и их средства взаимодействия (`методы`)
* *`объекты` сами знают, как себя изменять*
* удобно проектировать - аналогия объектов близка к реальному миру
* как правило, производительность ниже, чем в процедурных языках
* любой ООП-код может быть отражен в процедурный код

---

# ООП

## Аналогии реального мира

* `Телевизор`: может изменить состояние (канал, громкость) только при помощи пульта. Заведомо неверное состояние выставить с пульта невозможно.
Если разобрать телевизор и подать импульс на нужный элемент схемы, канал тоже переключится, но разбирать телевизор нельзя.
```perl
$tv->remote->set_channel(1);
```
* `Турникет`: на вход получает другой объект - карту. Если поездки на карте есть, турникет изменяет состояние - открывается, а чип карты
получает команду списать поездку. Добавить поездку через интефейс карты невозможно.
```perl
# $gate->open_by_card($card);
if ($card->has_passes) {
        $card->spend_pass; $gate->open;
}
```

---

# ООП: три кита

## Различные языки программирования реализуют данные сущности по-разному. Единственно верной реализации ООП не существует.

* инкапсуляция
    * свойство системы, позволяющее объединить данные и методы, работающие с ними, в классе
    * некоторые языки отождествляют инкапсуляцию с сокрытием реализации, другие различают эти понятия
* наследование
    * свойство системы, позволяющее описать новый класс на основе уже существующего с частично или полностью заимствующейся функциональностью
* полиморфизм
    * свойство системы, позволяющее использовать объекты с одинаковым набором методов без знания типа и внутренней реализации объекта

---

# ООП: программные сущности

* `класс`
    * комплексный тип данных, состоящий из тематически единого набора `свойств` (переменных более элементарных типов) и `методов` (функций для работы с этими свойствами)
    * модель информационной сущности с внутренним и внешним интерфейсами для оперирования своим содержимым (значениями свойств)
    * свойства часто называют `атрибутами`, `полями`
* `объект`
    * экземпляр `класса`
    * набор значений `свойств`, привязанный к классу и его `методам`

.center[.normal-width[![image](mandarinki.jpg)]]

---

layout: true
.footer[[perlootut](http://perldoc.perl.org/perlootut.html)]

---

# Особенности ООП в perl

## `Объект` = `свойства` с данными + `методы` для работы с ними

* `свойства` - элементы базовой структуры (скаляр, элементы хеша или массива, и т. д.)
* `класс` - пакет, связанный с базовой структурой
* `методы` - функции, объявленные в пакете
* `объект` - ссылка (!) на базовую структуру, связанная с классом

---

# Особенности ООП в perl

* набор свойств не описывается в классе и ограничивается лишь базовой структурой
.floatright[![Right-aligned image](woodpecker-destroyer.jpg)]
    * вы можете использовать любые элементы базовой структуры в качестве свойств объекта
    * нельзя ограничить набор свойств конкретным списком
    * сокрытие реализации отсутствует: нет возможности сделать private-свойства, все свойства доступны снаружи и могут быть изменены
    * любой дятел может разрушить цивилизацию
* неявная типизация
    * "если это выглядит как утка, плавает как утка и крякает как утка, то это возможно и есть утка"
    * набор методов объекта определяет границы его использования
    * можно использовать некий объект там же, где уже используется объект совсем другого класса, если у него есть необходимые методы и свойства
    * нет возможности создавать private- или protected-методы

---

layout: false

# Базовый синтаксис

### Задача: переделать на объекты пример из предыдущей лекции (модуль `Local::User` и скрипт для проверки авторизации)

* выбор базовой структуры и пакета, описание свойств и методов
* методы класса и методы объекта: синтаксис и различия
* функция `bless` и написание конструкторов
* использование аксессоров
* деструкторы
* наследование

???
Исходные файлы лежат в lecture/mod/example
Не забываем убрать Exporter и ликвидировать импортирование функций из сторонних модулей.
Дойдя до написания bless показать пару слайдов про него.
Дойдя до аксессоров показать слайд "name - свойство или метод?" и следующие за ним 2 слайда
Деструкторы можно показать на слайде.
Наследование: разбить welcome_text на методы greeting и name, показать наследование для класса Local::Teacher (greeting = Уважаемый преподаватель)
По возможности показать наследование конструктора с более сложной инициализацией в потомке

---

# Базовый синтаксис

## Пишем класс `Local::User`

* базовая структура - хеш
* свойства:
```perl
    first_name => 'Василий',
    last_name  => 'Пупкин',
    gender     => 'm',
    email      => 'vasily@pupkin.ru',
    passwd     =>
      '$1$f^34d*$24cc1e0d198dbf6bbfd812a30f1b4460',
```

---

# Базовый синтаксис

## Пишем класс `Local::User`

* никакого `Exporter`!
* методы:
```perl
  get_by_email
  name
  welcome_string
  is_password_valid
```

---

# Базовый синтаксис

## Пишем класс `Local::User`

### Все в консоль!

.center[.normal-width[![image](donald-dance.jpg)]]

---

# Базовый синтаксис

## Создание объекта

```perl
$object = bless \%data, $class;
# $object = \%data linked to package $class
```

```perl
$obj = \%data;
bless $obj, $class;
# the same as $obj = bless \%data, $class
```
--
```perl
bless \%data, $class;
bless \@data, $class;
bless \$data, $class;
```
--
```perl
bless \%data;
# same as bless \%data, __PACKAGE__;
```

---

# Базовый синтаксис

## Создание объекта

```perl
my $obj = \%data;
print ref $obj;               # HASH

bless $obj, "Local::User";
print ref $obj;               # Local::User
```
--
```perl
use Scalar::Util 'blessed';

my $obj = \%data;
print blessed $obj;           # undef

bless $obj, "Local::User";
print blessed $obj;           # Local::User
```

---

# Базовый синтаксис

## Вызов методов

```perl
$object = Some::Class->new(%args);
$value = $object->get_some_field();
$object->set_some_field($value);
```
--

## Непрямой вызов методов

```perl
my $object = `new` Some::Class(%args);

my $object = Some::Class`->new`(%args);
```

---

# Базовый синтаксис

## Непрямой вызов методов

```perl
use strict;
use warnings;

Syntax error!

exit 0;
```

--

```perl
error->Syntax( ! exit(0) );
```

.center[.normal-width[![image](woodpecker-alldone.jpg)]]

---

# Базовый синтаксис

## name - свойство или метод?

```perl
print $user->{first_name};        # Василий
print $user->{last_name};         # Пупкин
print $user->name();              # Василий Пупкин
```

---

# Базовый синтаксис

## Аксессоры (accessors)

```perl
sub first_name {
    my $self = shift;
    $self->{first_name} = $_[0] if @_;
    return $self->{first_name};
}
```

--

## getters/setters

```perl
sub get_first_name { $_[0]->{first_name} }
sub set_first_name {
    my $self = shift;
    $self->{first_name} = $_[0];
    return $self->{first_name};
}
```

---

# Базовый синтаксис

## Аксессоры (accessors)

* **Class::XSAccessor**
* Class::Accessor::Fast
* Class::Accessor
* ...

```perl
package Local::User;

# no passwd accessor - it is private!
use Class::XSAccessor {
  accessors => [qw/
    gender email first_name middle_name last_name
  /],
};
...
```

---

# Базовый синтаксис

## Деструкторы

```perl
package Local::User;

sub DESTROY {
  my ($self) = @_;
  print 'DESTROYED: ', $self->name, "\n";
}
```

```perl
{
  my $user =
    Local::User->get_by_email('vasily@pupkin.ru');
  # ...
}                      # DESTROYED: Василий Пупкин
```

---

# Базовый синтаксис

## Наследование

```perl
package Local::Student;
*BEGIN { our @ISA = ('Local::User'); }
```
--
```perl
package Local::Teacher;
*use base 'Local::User';
```
--
```perl
package Local::Professor;
*use parent 'Local::Teacher';
```
--
```perl
say Local::Professor->isa("Local::Teacher");# 1
say Local::Professor->isa("Local::User");   # 1
say Local::Professor->isa("Local::Student");# undef
```

---

# Базовый синтаксис

## Наследование: класс UNIVERSAL

```perl
# ???
say Local::Professor->isa("UNIVERSAL");     # 1
```
--
```perl
my $professor = Local::Professor->new;
say $professor->isa("Local::Teacher");      # 1

say UNIVERSAL::isa({}, "Local::User");      # undef
```
--
```perl
say ref Local::Professor->can("new");       # CODE
say $professor->can("scream");              # undef
```
--
```perl
say Local::User->VERSION;                   # 1.4
```

---
layout: false

# ООП: примеры применения

## import/unimport

```perl
use Some::Package qw(a b c);
# Some::Package->import(qw(a b c));

no Some::Package;
# Some::Package->unimport;

use Some::Package 10.01
# Some::Package->VERSION(10.01);
```

---

# ООП: примеры применения

## Конвейерные вызовы методов

```perl
use JSON::XS;

JSON::XS->new->utf8->decode('...');

decode_json '...';
```

---

# ООП: примеры применения

## Исключения (exceptions)

```perl
eval {
  die Local::Exception->new();
  1;
} or do {
  my $error = $@;

  if (
    blessed($error) &&
    $error->isa('Local::Exception')
  ) {
     # ...
  } else {
    die $error;
  }
};
```

---

# ООП: примеры применения

## Исключения (exceptions)

```perl
use Try::Tiny;
try {
  die 'foo';
} catch {
  warn "caught error: $_"; # not $@
};
```

```perl
use Error qw(:try);
try {
    throw Error::Simple 'Oops!';
}
catch Error::Simple with { say 'Simple' }
except                   { say 'Except' }
otherwise                { say 'Otherwise' }
finally                  { say 'Finally' };
```

---

# ООП: примеры применения

## Модуль `DBI`

```perl
$dbh = DBI->connect(
  $data_source,
  $username,
  $auth,
  \%attr
);

$rv = $dbh->do('DELETE FROM table');
```

---

# ООП: примеры применения

## Модуль `LWP`

```perl
use LWP::UserAgent;
my $ua = LWP::UserAgent->new(agent => "MyAgent");

my $req = HTTP::Request->new(
  GET => 'http://search.cpan.org/search?q=LWP'
);

my $res = $ua->request($req);
if ($res->is_success) {
    print $res->content;
} else {
    print $res->status_line;
}
```

---

# ООП: паттерны проектирования

* singleton
* adapter
* decorator
* iterator
* ...

---

# ООП: паттерны проектирования

## Паттерн singleton

```perl
$a = Some::Singleton->instance;
$b = Some::Singleton->instance;   # same as $a
```

```perl
our $INSTANCE;
sub instance {
    my $class = shift;
    ${ "${class}::INSTANCE" } ||= bless {}, $class;
}
```

```perl
use parent 'Class::Singleton';
sub _new_instance {
    my $class = shift;
    bless {}, $class;
}
```

---

# ООП: паттерны проектирования

## Паттерн adapter

```perl
sub set_name {
    my $self = shift;
    my $name = shift;
*   $self->name($name);
}

sub get_name {
    my $self = shift;
*   $self->name;
}
```

---

# ООП: паттерны проектирования

## Паттерн decorator

```perl
*package Local::Math;
sub new { bless {}, $_[0] }
sub exp {
    my ($self, $num, $exp) = @_;
    return $num ** $exp;
}
*package Local::Math::Fast;
sub new {
    my ($class, $local_math_obj) = @_;
    bless {obj=>$local_math_obj,cache=>{}}, $class;
}
sub exp {
    my ($self, $num, $exp) = @_;
    $self->{cache}{"$num**$exp"} ||=
        $self->{obj}->exp($num, $exp);
}
```
    
---

# ООП: паттерны проектирования

## Паттерн iterator

```perl
my @fetched_data;
my $iterator = Some::Iterator->new($data_source);
while ($iterator->has_next) {
    push @fetched_data, $iterator->next;
}
```

---

# Домашнее задание
##  Прагма `myconst`

https://github.com/Nikolo/Technosfera-perl/

`/homeworks/myconst`

Требуется написать модуль `myconst`, предназначенный для создания констант и управления их экспортированием. На вход модулю подается набор пар "ключ - значение".
В случае, если "значением" является скаляр, модуль должен создать константу с именем, содержащимся в "ключе". Если же "значение" - ссылка на хеш, то "ключ"
является именем группы констант, а имена и значения констант содержатся в хеше.

Ссылки в качестве значений констант не допускаются.

Модуль делает все константы доступными для экспортирования. Если на вход модулю поданы группы констант, то эти группы должны быть также доступны для экспортирования.
Кроме того, все константы дополнительно попадают в группу `all`.

---

# Домашнее задание
##  Прагма `myconst`

```perl
package Foo;

use myconst math => {
                PI => 3.14,
                E => 2.7,
            },
            ZERO => 0,
            EMPTY_STRING => '';

print ZERO;             # 0
print PI;               # 3.14
```

---

# Домашнее задание
##  Прагма `myconst`

```perl
package Foo::Bar;

use Foo qw/:math ZERO/;

print ZERO;             # 0
print PI;               # 3.14
```

```perl
package Foo::Bar::Baz;

use Foo qw/:all/;

print EMPTY_STRING;     # ''
print PI;               # 3.14
```

---

# Домашнее задание
## Reducer

https://github.com/Nikolo/Technosfera-perl/

`/homeworks/oop_reducer`

Требуется написать классы для проведения над логами операции [схлопывания](https://en.wikipedia.org/wiki/Fold_(higher-order_function)) (reduce).

---

# Всем спасибо!

.center[.normal-width[![image](donald-leaves.jpg)]]

---

class:lastpage title

# Спасибо за внимание!

## Оставьте отзыв

.teacher[![teacher]()]
