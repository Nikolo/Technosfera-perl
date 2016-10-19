class: firstpage title

# Программирование на Perl

## Объекты и ООП

---

class:note_and_mark title

# Отметьтесь на портале!
 
---

layout: true

.footer[[perlobj](http://perldoc.perl.org/perlobj.html)]

---

# План занятия

1. Немного теории
    * сравнение процедурного и объектно-ориентированного подходов
    * основные понятия и определения из мира ООП
    * особенности реализации ООП в perl
1. Базовый синтаксис для ООП в perl
    * конструкторы и деструкторы
    * методы класса и методы объекта
    * аксессоры
    * наследование и композиция объектов
1. Расширенные возможности ООП в perl
    * `overload`: перегрузка операторов при работе с объектами
    * `tie`: объект под капотом переменной
    * `AUTOLOAD`: неявно существующие методы
1. Примеры применения ООП в perl
1. Паттерны проектирования
1. `Moose` и `Mouse`: "принципиально новая" концепция

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

* `Конвеер`: детали двигаются по конвееру и на каждом этапе над ними производятся действия. Конвеер, как набор функций, неизменен, детали-данные меняются.
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

```perl
bless \%data, $class;
bless \@data, $class;
bless \$data, $class;
```

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

```perl
use Scalar::Util 'blessed';

my $obj = \%data;
print blessed $obj;           # undef

bless $obj, "Local::User";
print blessed $obj;           # Local::User
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

---

# Базовый синтаксис

## Непрямой вызов методов

```perl
use strict;
use warnings;

Syntax error!

exit 0;
```

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

# Базовый синтаксис

## Композиция объектов

```perl
package Local::Resident;
use Class::XSAccessor {
    accessors => [qw/snils inn passport/],
};

package Local::Passport;
use Class::XSAccessor {
    accessors => [qw/id emission date/],
};
```

```perl
$passport = Local::Passport->get_by_id($id);
$resident_user->passport($passport);
print $resident_user->passport->emission;

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

## Конвеерные вызовы методов

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

# ООП: примеры применения

## Модуль `Math::Int64`

```perl
use Math::Int64 qw(int64 uint64);

my $i = int64(1);
my $j = $i << 40;
print($i + $j * 1000000);

my $k = uint64("12345678901234567890");
```

---

# ООП: примеры применения

## Модули `IO::Handle`, `IO::File`, `IO::Socket`

```perl
$io = IO::Handle->new;
if ($io->fdopen(fileno(STDOUT),"w")) {
    $io->print("Some text\n");
*   print $io "Other text\n";
    $io->close;
}
```

```perl
if ($io = IO::File->new($filename, "w")) {
    $io->autoflush(1);
    $io->print("Some text\n");
}
```

```perl
$sock = IO::Socket::INET->new(PeerAddr => $host,
                              PeerPort => $port);
$sock->print("Some data");
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

# ООП: best practices

* композиция vs наследование
* `AUTOLOAD` vs генерация методов
* аксессоры vs использование базовой структуры
* паттерны проектирования
* встроенное "легкое ООП" vs `Moose`

---

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

# Домашнее задание

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
