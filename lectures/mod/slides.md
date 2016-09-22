class: firstpage title

# Программирование на Perl

## Модульность

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
    * пакеты и таблицы символов
    * области видимости
    * фазы компиляции и выполнения
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

---

# Функция `eval`

```perl
my $E = 2.72;

print "eval=",                    # eval=3.14159265
    eval('
        warn "Loading...\n";
        sub pow { $_[0] ** $_[1]; }
        $E = 2.71828183;
        my $PI = 3.14159265;
    '),
    "\n";

print "pow(2,8)=",pow(2,8),"\n";  # pow(2,8)=256
print "E=$E\n";                   # E=2.71828183
print "PI=$PI\n";                 # PI=undef
```

---

# Функция `do`

## `do` = open + eval?

* видит переменные, объявленные снаружи
* имеет свою область видимости
* возвращает последнее вычисленное значение
* возвращает `undef` и устанавливает `$!` в случае ошибки открытия файла
* возвращает `undef` и устанавливает `$@` в случае ошибки компиляции/выполнения

---

# Функция `do`

## `do` = open + eval?

```perl
# Local/Math.pm

warn "Loading...\n";

sub pow { $_[0] ** $_[1]; }

$E = 2.71828183;

my $PI = 3.14159265;
```

---

# Функция `do`

## `do` = open + eval?

```perl
sub my_do {
    my ($file) = @_;
    $! = $@ = undef;

    open my $fd, '<', $file or return;
    my $code = join '', <$fd>;
    close $fd;

    eval $code;
}

print 'my_do=',                     # Loading...
    my_do("Local/Math.pm"),"\n";    # do=3.14159265
print '$@=', $@, "\n";              # $@=undef
print '$!=', $!, "\n";              # $!=undef
print 'pow(2,8)=', pow(2,8), "\n";  # pow(2,8)=256
```
---

# Функция `do`

## `do` = open + eval?

```bash
*$ perl -e 'print join "\n", @INC' | head –3
/usr/local/lib64/perl5
/usr/local/share/perl5
/usr/lib64/perl5/vendor_perl
```

```bash
*$ PERL5LIB=/home/www/lib \
*>     perl -e 'print join "\n", @INC' | head -2
/home/www/lib
/usr/local/lib64/perl5
```

```bash
*$ perl -I/home/www/lib \
*>     -e 'print join "\n", @INC' | head -2
/home/www/lib
/usr/local/lib64/perl5
```

---

# Функция `do`

## `do` = open + eval + @INC!

```perl
# simplified implementation
sub find_in_inc {
    my ($file) = @_;
    return $file if $file =~ m!^/!;
    foreach my $path (@INC) {
        return "$path/$file" if -f "$path/$file";
    }
    die "Can't find file $file in \@INC";
}

sub my_do {
    my ($file) = @_;
    $file = find_in_inc($file);

    # ...
}
```

---

# Функция `require`

## `require` = do + die + %INC?

* останавливает выполнение в случае ошибки открытия файла, компиляции или выполнения
* не пытается загрузить и выполнить файл, если он уже был загружен ранее
* проверяет последнее вычисленное значение, останавливает выполнение, если оно ложно
* при первой загрузке файла возвращает последнее вычисленное значение, при последующих попытках его загрузить возвращает 1

---

# Функция `require`

## `require` = do + die + %INC?

```perl
# simplified implementation
sub my_require {
    my ($file) = @_;
    return 1 if $INC{$file};

    my $filepath = find_in_inc($file)
        or die "Can't find $file in \@INC";

    my $result = do $filepath
        or die "$file did not return true value";
    die $@ if $@;

    $INC{$file} = $filepath;
    return $result;
}
```

---

# Функция `require`

## `require` = do + die + %INC?

```perl
$E = 2.72;
                               # Loading...
require "Local/Math.pm";       # 3.14159265
print "E=$E\n";                # E=2.71828183

$E = 2.72;
require "Local/Math.pm";       # 1
print "E=$E\n";                # E=2.72
```

---

# Пакеты

```perl
require "Some/Module.pm";
some_function();

require "Another/Module.pm";
some_function();                # WTF?!
```

---

# Пакеты

```perl
require "Some/Module.pm";
Some::Module::some_function();          # fqn

require "Another/Module.pm";
Another::Module::some_function();       # fqn
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

```perl
*package Local::Math;
$PI = 3.14159265;
sub pow  { $_[0] ** $_[1] }
sub sqr  { pow($_[0], 0.5) }
# the same
# sub sqr { Local::Math::pow($_[0], 0.5) }

*package main;
print "sqr(4)=",
    Local::Math::sqr(4), "\n";  # sqr(4)=2
print "fqn PI=", 
    $Local::Math::PI, "\n";     # fqn PI=3.14159265
print "PI=$PI\n";               # PI=undef
```

---

# Пакеты

```perl
*package Local::Math;
sub pow  { $_[0] ** $_[1] }

*package main;
$Local::Math::PI = 3.14159265;
sub Local::Math::sqr {
    Local::Math::pow($_[0], 0.5)
}

print "sqr(4)=",
    Local::Math::sqr(4), "\n";  # sqr(4)=2
print "fqn PI=", 
    $Local::Math::PI, "\n";     # fqn PI=3.14159265
print "PI=$PI\n";               # PI=undef
```

---

# Пакеты

```perl
# Local/Math.pm
package Local::Math;
sub pow  { $_[0] ** $_[1] }

printf "Pkg %s, file %s, line %d\n",
    __PACKAGE__, __FILE__, __LINE__;           
# Pkg Local::Math, file Local/Math.pm, line 4

# :-)
1;
```

---

# Пакеты

```perl
# script.pl
require "Local/Math.pm";

printf "Pkg %s, file %s, line %d\n",
    __PACKAGE__, __FILE__, __LINE__;
# Pkg main, file script.pl, line 3
```

---

# Пакеты

```perl
# script.pl
{
    package Local::Math;
    sub sqr {pow($_[0], 0.5) }
    
    printf "Pkg %s, file %s, line %d\n",
        __PACKAGE__, __FILE__, __LINE__;
    # Pkg Local::Math, file script.pl, line 5
}

printf "Pkg %s, file %s, line %d\n",
    __PACKAGE__, __FILE__, __LINE__;             
# Pkg main, file script.pl, line 11

```

---

# Таблицы символов

```perl
package Some::Package {
    $var = 500; 
    @var = (1,2,3);
    %func = (1 => 2, 3 => 4);
    sub func { return 400 }
    open F, "<", "/dev/null";
}
package Some::Package::Deeper {}

printf "%-10s => %s\n", $_, $Some::Package::{$_}
    foreach keys %Some::Package::;
```

```perl
F          => *Some::Package::F
Deeper::   => *Some::Package::Deeper::
var        => *Some::Package::var
func       => *Some::Package::func
```

---

# Таблицы символов

* TYPEGLOB: `*foo`
    * SCALAR: `$foo`
    * ARRAY: `@foo`
    * HASH: `%foo`
    * CODE: `&foo`
    * IO:  `foo`
    * NAME: `"foo"`
    * PACKAGE: `"main"`

---

# Таблицы символов

```perl
 package Local::Math {
     $PI = 3.14159265;
     sub PI { print 3.14 }
 }

* *Other::Math::PI = *Local::Math::PI;
 print $Other::Math::PI, "\n";         # 3.14159265
 Other::Math::PI();                    # 3.14
```

---

# Таблицы символов

```perl
 package Local::Math {
     $PI = 3.14159265;
     sub PI { print 3.14 }
 }

* *Other::Math::PI = \$Local::Math::PI;
 print $Other::Math::PI, "\n";         # 3.14159265
 Other::Math::PI();
 # Undefined subroutine &Other::Math::PI called
```

---

# Таблицы символов

```perl
 package Local::Math {
     $PI = 3.14159265;
     sub PI { print 3.14 }
 }

* *Other::Math::PI = \&Local::Math::PI;
 print $Other::Math::PI, "\n";         # undef
 Other::Math::PI();                    # 3.14
```

---

# Таблицы символов

```perl
 *PI = \3.14159265;
 print $PI, "\n";      # 3.14159265
 $PI = 4;
 # Modification of a read-only value attempted
```

```perl
 $glob = *FH;
 print *{$glob}{PACKAGE}, "::", *{$glob}{NAME};
 # main::FH
```

---

# Области видимости

```perl
package Local::Math;
*our $PI = 3.14159265;

package main;
print $PI, "\n";                      # 3.14159265
print $::PI, "\n";                    # undef
print $Local::Math::PI, "\n";         # 3.14159265
```

---

# Области видимости

```perl
package Local::Math;
*my $PI = 3.14159265;

package main;
print $PI, "\n";                      # 3.14159265
print $::PI, "\n";                    # undef
print $Local::Math::PI, "\n";         # undef
```

---

# Области видимости

```perl
my $x = 4;
{
    my $x = 5;
    print $x, "\n"; # 5
}
print $x, "\n"; # 4
```

---

# Области видимости

```perl
use feature 'state';

sub test {
    state $x = 42;
    return $x++;
}

printf(                            # 42 43 44 45 46
    '%d %d %d %d %d',
    test(),test(),test(),test(),test()
);

print $x;                          # undef
```

---

# Области видимости

```perl
our $x = 10;
our %y = (x => 20, y => 30);
{
    local $x = -10;
    local $y{x} = -20;
    print $x, "\n";                # -10
    print $y{x}, "\n";             # -20
}
print $x, "\n";                    #  10
print $y{x}, "\n";                 #  20
```

---

# Области видимости

```perl
# 1,2,3
{
    local $/ = ",";
    $x=<>; $y = <>; $z=<>;       # "1," "2," "3\n"
    chomp $y;                    # "2"
}
chomp $z;                        # "3"

# 1\n2\n3\n
{
    local $/;
    $all = <>;                   # "1\n2\n3\n"
}
```

---

# Функция `require`

## `require`=do+die+%INC+namespace!

```perl
require "/home/www/lib/Local/Math.pm";
require "Local/Math.pm";
require Local::Math;                   # BAREWORD!
```

---

# Функция `require`

## `require`=do+die+%INC+namespace!

```perl
sub pkg_to_filename {
    my ($pkg) = @_;
    $pkg =~ s!::!/!g;
    return "${pkg}.pm";
}

sub my_require {
    my ($file) = @_;

    # simplified implementation
    $file = pkg_to_filename($file)
        unless $file =~ m![./]!;

    # ...
}
```

---

# Фазы работы интерпретатора

`${^GLOBAL_PHASE}` – фаза работы интерпретатора perl
* CONSTRUCT
* START
* CHECK
* INIT
* RUN
* END
* DESTRUCT

---

# Фазы работы интерпретатора

```perl
        warn "[${^GLOBAL_PHASE}] Runtime 1\n";
END   { warn "[${^GLOBAL_PHASE}] End 1\n"       }
CHECK { warn "[${^GLOBAL_PHASE}] Check 1\n"     }
UNITCHECK
      { warn "[${^GLOBAL_PHASE}] UnitCheck 1\n" }
INIT  { warn "[${^GLOBAL_PHASE}] Init 1\n"      }
BEGIN { warn "[${^GLOBAL_PHASE}] Begin 1\n"     }
END   { warn "[${^GLOBAL_PHASE}] End 2\n"       }
CHECK { warn "[${^GLOBAL_PHASE}] Check 2\n"     }
UNITCHECK
  { warn "[${^GLOBAL_PHASE}] UnitCheck 2\n"     }
INIT  { warn "[${^GLOBAL_PHASE}] Init 2\n"      }
BEGIN { warn "[${^GLOBAL_PHASE}] Begin 2\n"     }
        warn "[${^GLOBAL_PHASE}] Runtime 2\n";
```

---

# Фазы работы интерпретатора

```perl
[START] Begin 1
[START] Begin 2
[START] UnitCheck 2
[START] UnitCheck 1
[CHECK] Check 2
[CHECK] Check 1
[INIT] Init 1
[INIT] Init 2
[RUN] Runtime 1
[RUN] Runtime 2
[END] End 2
[END] End 1
```

---

# Фазы работы интерпретатора

* `require` использует `eval`
* `mod_perl` выполняет приложение, используя `eval`
* как работают фазы и специальные блоки в `eval`?

---

# Фазы работы интерпретатора

```perl
warn "[${^GLOBAL_PHASE}] --- BEFORE EVAL\n";
eval '
          warn "[${^GLOBAL_PHASE}] Runtime\n";
  END   { warn "[${^GLOBAL_PHASE}] End\n"       }
  CHECK { warn "[${^GLOBAL_PHASE}] Check\n"     }
  UNITCHECK
        { warn "[${^GLOBAL_PHASE}] UnitCheck\n" }
  INIT  { warn "[${^GLOBAL_PHASE}] Init\n"      }
  BEGIN { warn "[${^GLOBAL_PHASE}] Begin\n"     }
';
warn "[${^GLOBAL_PHASE}] --- AFTER EVAL\n";
```

---

# Фазы работы интерпретатора

```perl
[RUN] --- BEFORE EVAL
[RUN] Begin
[RUN] UnitCheck
[RUN] Runtime
[RUN] --- AFTER EVAL
[END] End
```

```perl
# RUN?
# CHECK?!
# INIT?!!
# END?!!!
```

---

# Фазы работы интерпретатора

```perl
# Local/Phases.pm
package Local::Phases;
BEGIN     { warn __PACKAGE__, " compile start\n" }
UNITCHECK { warn __PACKAGE__, " UNITCHECK\n"     }
CHECK     { warn __PACKAGE__, " CHECK\n"         }
INIT      { warn __PACKAGE__, " INIT\n"          }
            warn __PACKAGE__, " runtime\n";
BEGIN     { warn __PACKAGE__, " compile end\n"   }
```

```perl
# phases.pl
BEGIN     { warn __PACKAGE__, " compile start\n" }
UNITCHECK { warn __PACKAGE__, " UNITCHECK\n"     }
CHECK     { warn __PACKAGE__, " CHECK\n"         }
INIT      { warn __PACKAGE__, " INIT\n"          }
            warn __PACKAGE__, " runtime\n";
*           require Local::Phases;
BEGIN     { warn __PACKAGE__, " compile end\n"   }
```

---

# Фазы работы интерпретатора

```perl
main compile start
main compile end
main UNITCHECK
main CHECK
main INIT
main runtime
Local::Phases compile start
Local::Phases compile end
Local::Phases UNITCHECK
Local::Phases runtime
```

```perl
# Local::Phases CHECK ?!!
# Local::Phases INIT  ?!!
```

---

# Фазы работы интерпретатора

```perl
# Local/Phases.pm
package Local::Phases;
BEGIN     { warn __PACKAGE__, " compile start\n" }
UNITCHECK { warn __PACKAGE__, " UNITCHECK\n"     }
CHECK     { warn __PACKAGE__, " CHECK\n"         }
INIT      { warn __PACKAGE__, " INIT\n"          }
            warn __PACKAGE__, " runtime\n";
BEGIN     { warn __PACKAGE__, " compile end\n"   }
```

```perl
# phases.pl
BEGIN     { warn __PACKAGE__, " compile start\n" }
UNITCHECK { warn __PACKAGE__, " UNITCHECK\n"     }
CHECK     { warn __PACKAGE__, " CHECK\n"         }
INIT      { warn __PACKAGE__, " INIT\n"          }
            warn __PACKAGE__, " runtime\n";
*BEGIN     { require Local::Phases;               }
BEGIN     { warn __PACKAGE__, " compile end\n"   }
```

---

# Фазы работы интерпретатора

```perl
main compile start
Local::Phases compile start
Local::Phases compile end
Local::Phases UNITCHECK
Local::Phases runtime
main compile end
main UNITCHECK
*Local::Phases CHECK
main CHECK
main INIT
*Local::Phases INIT
main runtime
```

---

# Директива `use`

## `use` = BEGIN + require?

```perl
use Local::Math;   # BAREWORD
# BEGIN { require Local::Math; }

BEGIN { print Local::Math::pow(2, 8) } # 256
```

```perl
require Local::Math;

BEGIN { print Local::Math::pow(2, 8) }
# Undefined subroutine &Local::Math::pow
```

---

# Директива `use`

## `use` = BEGIN + require + import?

```perl
use Some::Module ();
```

```perl
BEGIN {
    require Some::Module;
}
```

```perl
# import?
```

---

# Директива `use`

## `use` = BEGIN + require + import?

```perl
use Some::Module;

BEGIN {
    require Some::Module;
    Some::Module::import("Some::Module"); # if can
}
```

```perl
use Some::Module ('arg1', 'arg2');

BEGIN {
    require Some::Module;
    Some::Module::import(                 # if can
        "Some::Module",
        'arg1', 'arg2'
    );
}
```

---

# Директива `use`

## `use` = BEGIN + require + import?

```perl
# Local/Math.pm
sub import {
    my $self = shift;
    my ($pkg) = caller(0);
    foreach my $func (@_) {
        *{"${pkg}::$func"} = \&{$func};
    }
}
```

```perl
# main.pl
use Local::Math qw/pow sqr/;
print pow(2,8), "\n";             # 256
```

---

# Директива `use`

## `use` = BEGIN + require + import?

```perl
# Local/Math.pm
sub unimport {
    my $self = shift;
    my ($pkg) = caller(0);
    foreach my $func (@_) {
        delete ${"${pkg}::"}{$func};
    }
}
```

```perl
# main.pl
use Local::Math qw/pow sqr/;
print pow(2,8), "\n";             # 256

no Local::Math qw/pow/;
print pow(2,8), "\n";
# Undefined subroutine &main::pow called
```

---

# Директива `use`

## `use` = BEGIN + require + import + version!

```perl
# Local/Math.pm
package Local::Math;
$VERSION = 1.25;

# package Local::Math 1.25;

print $Local::Math::VERSION;  # 1.25
```

```perl
# main.pl
use Local::Math 1.26;
# Local::Math version 1.26 required--this is
#     only version 1.25
```

---

# Директива `use`

## `use` = BEGIN + require + import + version!

```perl
package Local::Math;
$VERSION = v1.25.01;
print $Local::Math::VERSION;  # ???
```

```perl
print v67.97.109.101.108.33;  # Camel!
```

```perl
package Local::Math v1.25.01;
print $Local::Math::VERSION;  # v1.25.01
```

```perl
use Local::Math v1.26.2;
# Local::Math version v1.26.2 required--this is
#     only version v1.25.1
```

---

# Директива `use`

## `use` = BEGIN + require + import + version!

```perl
use 5.20;
# Perl v5.200.0 required (did you mean v5.20.0?)--
#     this is only v5.16.3, stopped
```

```perl
use v5.20;
# Perl v5.20.0 required--this
# is only v5.16.3, stopped
```

```perl
use 5.020_000;
# Perl v5.20.0 required--this
# is only v5.16.3, stopped
```

---

# Стандартные модули

## Модуль `Exporter`

```perl
 package Local::Math;

 use Exporter;
 *import = \&Exporter::import;
 @EXPORT_OK = qw/$PI pow sqr/;
 %EXPORT_TAGS = (
     func  => [ qw/pow sqr/ ],
     const => [ qw/$PI $E/  ],
 );
 @EXPORT = qw/$PI/;

 $PI = 3.14159265;
 $E = 2.71828183;
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

---

# Стандартные модули

## Модуль `Data::Dumper`

```perl
use Data::Dumper;

$u = \\3.14;
$v = *STDIN;
$w = "qwerty";
$x = sub { 1 };
@y = (1, "2", 3, "x");
%z = (x => 1, y => 2);

warn Dumper($u, $v, $w, $x, \@y, \%z);
```

---

# Стандартные модули

## Модуль `Data::Dumper`

```perl
$VAR1 = \\'3.14';
$VAR2 = *::STDIN;
$VAR3 = 'qwerty';
$VAR4 = sub { "DUMMY" };
$VAR5 = [
          1,
          '2',
          3,
          'x'
        ];
$VAR6 = {
          'y' => 2,
          'x' => 1
        };
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

## Модуль `POSIX`

```perl
use POSIX ();
```

```perl
print POSIX::ceil(2.72), "\n";             # 3
print POSIX::floor(2.72), "\n";            # 2
```

```perl
print POSIX::strftime("%Y-%m-%d %T / %B",
    localtime(0)), "\n";
# 1970-01-01 03:00:00 / January

use POSIX qw(setlocale LC_ALL);
setlocale(LC_ALL, "ru_RU.UTF-8");

print POSIX::strftime("%Y-%m-%d %T / %B",
    localtime(0)), "\n";
# 1970-01-01 03:00:00 / Январь
```

---

# Прагмы

## Модуль `strict`

```perl
use strict 'vars';

our $foo = 1;                  # ok
my $bar = 2;                   # ok
$baz = 3;
# Global symbol "$baz" requires
#     explicit package name
```

---

# Прагмы

## Модуль `strict`

```perl
use strict 'refs';

$foo = "foo"; 
$ref = \$foo;
print $$ref;                   # foo

$ref = "foo";
print $$ref;
# Can't use string ("foo") as a SCALAR ref
#     while "strict refs" in use
```

---

# Прагмы

## Модуль `strict`

```perl
$x = \foo;
print $$x, "\n";               # foo
```

```perl
use strict 'subs';
$x = \"foo";                   # ok
$x = \foo;
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
{
    no strict 'refs';
    print $$ref;              # foo
}
print $$ref;
# Can't use string ("var") as a SCALAR ref
#     while "strict refs" in use
```

---

# Прагмы

## Модуль `warnings`

```perl
use warnings;
use warnings 'deprecated';

print "foo" . undef;                 # foo
# Use of uninitialized value in concatenation (.)
#     or string

no warnings 'uninitialized';
print "foo" . undef;                 # foo
```

```bash
$ perl -we 'print 5 + "a"'           # 5
# Argument "a" isn't numeric in addition (+)
```

---

# Прагмы

## Модуль `diagnostics`

```perl
use diagnostics;

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
use lib qw(/home/www/lib /home/www/lib2);
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
use feature qw/say state/;     # a lot of features
use feature ":5.10";           # features for 5.10

say 'New line follows this';

state $x = 10;
```

---

# Прагмы

## Модуль `constant`

```perl
use constant PI => 3.14159265;
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

# CPAN

```sh
$ perl –MCPAN -eshell
```

```sh
$ cpan
cpan shell -- CPAN exploration and modules installation (v1.7602)
ReadLine support available (try 'install Bundle::CPAN')

cpan> install Crypt::Rijndael
...
cpan> ?
```

---

# CPAN

```bash
wget http://search.cpan.org/CPAN/authors/id/L/LE/LEONT/Crypt-Rijndael-1.13.tar.gz
tar –xzf Crypt-Rijndael-1.13.tar.gz
cd Crypt-Rijndael-1.13
perl Makefile.PL
make
make test
make install
```

---

# CPAN

```bash
$ module-starter --module Local::Math \
>      --author Vadim --email vadim@pushtaev.ru
```

```
Local-Math/
├── Changes
├── ignore.txt
├── lib
│   └── Local
│       └── Math.pm
├── Makefile.PL
├── MANIFEST
├── README
└── t
    ├── 00-load.t
    ├── boilerplate.t
    ├── manifest.t
    ├── pod-coverage.t
    └── pod.t
```

---

# CPAN

```perl
# Makefile.PL
use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME           => 'Local::Math',
    AUTHOR         => 'Vadim <vadim@pushtaev.ru>',
    VERSION_FROM   => 'lib/Local/Math.pm',
    ABSTRACT_FROM  => 'lib/Local/Math.pm',
    LICENSE        => 'Artistic_2_0',
    PL_FILES       => {},
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    # ...
);
```

---

# CPAN

```bash
*$ apt-cache search libjson-perl
libjson-perl - module for manipulating
  JSON-formatted data
libjson-pp-perl - module for manipulating
  JSON-formatted data (Pure Perl)
libjson-xs-perl - module for manipulating
  JSON-formatted data (C/XS-accelerated)
```

```bash
*$ yum search perl-JSON
=============== Matched: perl-json ===============
perl-JSON-XS.x86_64 : JSON serialising/
   deserialising, done correctly and fast
perl-JSON.noarch : Parse and convert to JSON
  (JavaScript Object Notation)
perl-JSON-PP.noarch : JSON::XS compatible pure-Perl
  module
```

---

# Список литературы

* perldoc `perlmod`
* perldoc `perlvar`
* perldoc `perlfunc`
* perldoc `perlpragma`
* perldoc `perlmodlib`
* perldoc `cpan`
* perldoc `perlnewmod`
* perldoc `perlmodstyle`

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

# Пишем модуль

## Что дальше?
* заменяем устаревший MD5 на другой алгоритм хеширования (SHA512, bcrypt, scrypt)
* переносим информацию о пользователях в базу данных или другое внешнее хранилище
* добавляем функционал для регистрации новых пользователей и изменения существующих данных
* интегрируем модуль в веб-приложение
* ...

---

# Всем спасибо!

.center[.normal-width[![image](final.jpg)]]

---

class:lastpage title

# Спасибо за внимание!

## Оставьте отзыв

.teacher[![teacher]()]
