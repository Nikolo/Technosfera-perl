class: firstpage title

# Программирование на Perl

## Модули и ООП (продолжение)

---

class:note_and_mark title

# Отметьтесь на портале!

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

???
Каким же образом хранится информация о пакетах и относящихся к ним переменных, функциях?

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

# caller
## TODO

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
    delete ${"${pkg}::"}{$_} foreach @_;
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

# CORE::GLOBAL::
## TODO

---

# SIGDIE
## TODO

---

# SIGWARN
## TODO

---

# Carp
## TODO

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

???
Прежде чем мы перейдем к следующему, самому мощному и широкоиспользуемому инструменту для загрузки модулей,
нам нужно разобраться, что же происходит внутри интерпретатора перл во время его работы.

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

???
Показать, как работает BEGIN в консоли.

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

# bless

## TODO

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

## Деструкторы: грабли

* `die`
* `local`
* `AUTOLOAD`
* `${^GLOBAL_PHASE} eq 'DESTRUCT'`

```perl
sub DESTROY {
  my ($self) = @_;
  $self->{handle}->close() if $self->{handle};
}
```

.center[.normal-width[![image](woodpecker-gun.jpg)]]

---

# Базовый синтаксис

## Наследование

```perl
package Local::Student;
*BEGIN { our @ISA = ('Local::User'); }
```

```perl
package Local::Teacher;
*use base 'Local::User';
```

```perl
package Local::Professor;
*use parent 'Local::Teacher';
```

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

```perl
my $professor = Local::Professor->new;
say $professor->isa("Local::Teacher");      # 1

say UNIVERSAL::isa({}, "Local::User");      # undef
```

```perl
say ref Local::Professor->can("new");       # CODE
say $professor->can("scream");              # undef
```

```perl
say Local::User->VERSION;                   # 1.4
```

---

# Базовый синтаксис

## Множественное наследование

```perl
package Local::Resident;
use Class::XSAccessor {
  accessors => [qw/
    name snils inn
    passport_id passport_emission passport_date
  /],
};
```

```perl
package Local::ResidentStudent;
use parent qw/Local::Student Local::Resident/;
```

```perl
$resident_user->name(); # ???
# Local::Student->name or Local::Resident->name?
```

---

# Базовый синтаксис

## Множественное наследование: method resolution order

```
       Object
         |
       Stream  Cacheable
       /   \   /
 InStream   CacheableOutStream
       \   /
      IOStream
```

```perl
IOStream->some_method();
# IOStream InStream Stream Object
#     CacheableOutStream Cacheable
```

```perl
$self->SUPER::some_method(@params);

$self->Cacheable::some_method(@params);
```

---

# Базовый синтаксис

## Множественное наследование: method resolution order

```
       Object
         |
       Stream  Cacheable
       /   \   /
 InStream   CacheableOutStream
       \   /
      IOStream
```

```perl
use mro 'c3';

IOStream->some_method();
# IOStream InStream CacheableOutStream
#     Stream Object Cacheable
```

```perl
$self->next::method(@params);
```

---

layout: true

.footer[[overload](http://perldoc.perl.org/overload.html)]

---

# Расширенный синтаксис

## Модуль `overload`

```perl
package Local::User;
use overload '""' => 'to_string';
sub to_string {
    my ($self) = @_;
    return $self->name.' <'.$self->email.'>';
}
```

```perl
print $user;   # Василий Пупкин <vasily@pupkin.ru>
```

---

# Расширенный синтаксис

## Модуль `overload`

```perl
package Local::Vector;
use overload '+' => 'add', '0+' => 'len';
sub new {
    my ($class, $x, $y) = @_;
    bless { x=>$x, y=>$y }, $class;
}
sub add {
    my ($vec1, $vec2) = @_;
    __PACKAGE__->new(
        $vec1->{x} + $vec2->{x},
        $vec1->{y} + $vec2->{y},
    );
}
sub len {
    my ($self) = @_;
    return sqrt($self->{x}**2 + $self->{y}**2);
}
```

---

# Расширенный синтаксис

## Модуль `overload`

```perl
$vec1 = Local::Vector->new(1, 2);
$vec2 = Local::Vector->new(3, 1);

print $vec1+$vec2;    # 5
```

```perl
$vec1 = Local::Vector->new(1, 2);
$vec2 = Local::Vector->new(3, 1);

print Local::Vector::len(
    Local::Vector::add($vec1, $vec2);
);
```

---

layout: true

.footer[[perltie](http://perldoc.perl.org/perltie.html)]

---

# Расширенный синтаксис

## `tie`: объект под капотом переменной

```perl
$hash{x} = 'vasily@pupkin.ru';

print $hash{x};
# Василий Пупкин <vasily@pupkin.ru>

print ref $hash{x};
# Local::User

# WTF???
```

.center[.normal-width[![image](donald-facepalm.jpg)]]

---

# Расширенный синтаксис

## `tie`: объект под капотом переменной

```perl
package Local::UserHash;

use Tie::Hash;
use base 'Tie::StdHash';

use Local::User;

sub STORE {
  my ($self, $key, $value) = @_;
  $self->{$key} = 
    Local::User->get_by_email($value);
}
```

---

# Расширенный синтаксис

## `tie`: объект под капотом переменной

```perl
my %hash;
tie %hash, 'Local::UserHash';

$hash{x} = 'vasily@pupkin.ru';

print $hash{x};
# Василий Пупкин <vasily@pupkin.ru>
```

.center[.normal-width[![image](donald-facepalm2.jpg)]]

---
layout: true

.footer[[perlobj](http://perldoc.perl.org/perlobj.html)]

---

# Расширенный синтакисис

## `AUTOLOAD`

```perl
package Local::User;

sub get_by_email      { ... }
sub is_password_valid { ... }
sub name              { ... }

our $AUTOLOAD;
sub AUTOLOAD {
    my $self = shift;
    return $self->{$AUTOLOAD};
}
```

```perl
print $user->first_name();         # Василий
print $user->can('first_name');    # 0 :-(
```

---
layout: false

# Moose ООП

## Базовый синтаксис

```perl
package Local::User;
use Moose;
has first_name => (
  is  => 'rw',
  isa => 'Str',
);
has last_name => (
  is  => 'rw',
  isa => 'Str',
);
```

```perl
Local::User->new(
  first_name => 'Василий',
  last_name  => 'Пупкин',
);
```

---

# Moose ООП

## Наследование

```perl
package Local::Teacher;

use Moose;

extends 'Local::User';
```

---

# Moose ООП

## Инициализация объекта

```perl
has age      => (is => 'ro', isa => 'Int');
has is_adult => (is => 'rw', isa => 'Bool');

sub BUILD {
  my ($self) = @_;
  $self->is_adult($self->age >= 18);
  return;
}
```

---

# Moose ООП

## Отложенное выполнение

```perl
has age      => (is => 'ro', isa => 'Int');
has is_adult => (
  is => 'ro',
  isa => 'Bool',
  lazy => 1,
  default => sub {
    my ($self) = @_;
    return $self->age >= 18;
  }
);
```

---

# Moose ООП

## "Ленивые вычисления"

```perl
has age      => (is => 'ro', isa => 'Int');
has is_adult => (
  is => 'ro', isa => 'Bool',
  lazy => 1,  builder => '_build_is_adult',
);

sub _build_is_adult {
  my ($self) = @_;
  return $self->age >= 18;
}
```

```perl
package Local::SuperMan;
extends 'Local::User';
sub _build_is_adult { return 1; }
```

---

# Moose ООП

## "Ленивые вычисления"

```perl
has [qw(
  file_name
  fh
  file_content
  xml_document
  data
)] => (
  lazy_build => 1,
  # ...
);

sub _build_fh           { open($self->file_name) }
sub _build_file_content { read($self->fh) }
sub _build_xml_document { parse($self->file_content) }
sub _build_data         { find($self->xml_document) }
```

---

# Moose ООП

## Миксины

```perl
with 'Role::HasPassword';
```

```perl
package Role::HasPassword;
use Moose::Role;
use Some::Digest;

has passwd => (
  is => 'ro',
  isa => 'Str',
);

sub is_password_valid {
  my ($self, $passwd) = @_;
  ...
}
```

---

# Moose ООП

## Делегирование

```perl
has doc => (
  is    => 'ro',
  isa   => 'Item',
  handles => [qw(read write size)],
);
```

```perl
has last_login => (
  is    => 'rw',
  isa   => 'DateTime',
  handles => { 'date_of_last_login' => 'date' },
);
```

---

# Moose ООП

## Декораторы, типы, расширения

```perl
before 'is_adult' => sub { shift->recalculate_age }
```

```perl
subtype 'ModernDateTime'
  => as 'DateTime'
  => where { $_->year() >= 1980 }
  => message { 'The date is not modern enough' };

has 'valid_dates' => (
  isa => 'ArrayRef[DateTime]',
);
```

```perl
package Config;
use MooseX::Singleton; # instead of Moose
```

```perl
$meta = $class->meta;
```

---

# Moose — аналоги

* Moose
* *Mouse*
* Moo
* Mo
* M

.center[.normal-width[![image](donald-laugh.jpg)]]

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

# Module create master class
