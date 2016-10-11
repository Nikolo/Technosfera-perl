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
1. Примеры применения
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
    unless is_password_valid($user, $passwd);

say welcome_string($user);
say 'Добро пожаловать';
```

---

# Базовый синтаксис

## Пишем класс `Local::User`

```perl
#!/usr/bin/perl
use strict;
use feature 'say';
use Local::User;

my ($email, $passwd) = @ARGV;
die "USAGE: $0 <email> <password>\n“
    unless length $email && length $passwd;

my $user = Local::User->get_by_email($email);
die "Пользователь с адресом '$email' не найден\n"
    unless $user;
die "Введен неправильный пароль\n"
    unless $user->is_password_valid($passwd);

say $user->welcome_string;
say 'Добро пожаловать';
```

---

# Базовый синтаксис

## Пишем класс `Local::User`

```perl
# `first` imported from List::Util
sub get_by_email {
  my $email = shift;
  my $user_data =
    first { $_->{email} eq $email } @USERS;
* # ????
  return $user_object;
}
```

---

layout: true
.footer[[perlobj](http://perldoc.perl.org/perlobj.html)]

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

## Методы класса

```perl
sub new {
  my ($class) = shift;
  my %params = @_;
  $params{name} =
    "$params{first_name} $params{last_name}";
  bless \%params, $class;
}
```

```perl
$user = Local::User->new(
    email => 'vasily@pupkin.ru',
    gender => 'm',
    # ...
);
$class = "Local::User";
$user = $class->new;
```

---

# Базовый синтаксис

## Методы объекта

```perl
sub name {
  my $self = shift;
  return join ' ',
    grep { length $_ }
      map { $self->{$_} }
        qw/first_name middle_name last_name/;
}
print $user->name;           # Василий Пупкин
# print $user->name();       # same
```

```perl
sub some_method {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    ...
}
```

---

# Базовый синтаксис

## Непрямой вызов методов

```perl
new Local::User(email => 'vasily@pupkin.ru');
# Local::User->new(email => 'vasily@pupkin.ru');
```

```perl
is_valid_password $user("123");
# $user->is_valid_password("123");
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

---

# Базовый синтаксис

## Пишем класс `Local::User`

```perl
# $user_obj = Local::User->get_by_email($email);

sub get_by_email {
  my ($class, $email) = @_;
  my $user_data =
    first { $_->{email} eq $email } @USERS;
* my $user_object = bless $user_data, $class;
  return $user_object;
}
```

---

# Базовый синтаксис

## Пишем класс `Local::User`

```perl
sub welcome_string {
  my $self = shift;
  return $self->greeting . ' ' . $self->name . "!";
}
sub greeting {
  my $self = shift;
  return (
    $self->gender eq 'm' ?
    "Уважаемый" : "Уважаемая"
  );
}
sub is_password_valid {
  my ($self, $passwd) = @_;
  # ...
}
```

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
    return $self->{first_name};
}
```

## getters/setters

```perl
sub get_first_name { $_[0]->{first_name} }
sub set_first_name {
    my $self = shift;
    $self->{first_name} = $_[0] if @_;
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

## Пишем класс `Local::User`

```perl
sub name {
  my $self = shift;
  return join ' ',
    grep { length $_ }
*     map { my $m="${_}_name"; $self->$m }
        qw/first middle last/;
}
```

---

# Базовый синтаксис

## Деструкторы

```perl
package Local::User;

sub DESTROY {
  my ($self) = @_;
  print 'DESTROYED: ', $self->name;
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

## Пишем класс `Local::User`

```perl
package Local::Teacher;
use strict;
use warnings;
use base 'Local::User';

sub greeting {
  my $self = shift;
  return (
    $self->gender eq 'm' ?
      "Уважаемый преподаватель" :
      "Уважаемая преподаватель"
  );
}

```

---

# Базовый синтаксис

## Пишем класс `Local::User`

```perl
package Local::Teacher;
use strict;
use warnings;
use base 'Local::User';

sub greeting {
  my $self = shift;
  return $self->SUPER::greeting . "преподаватель";
}
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
IOStream->method();
# IOStream InStream Stream Object
#     CacheableOutStream Cacheable
```

```perl
$self->SUPER::method(@params);

$self->Cacheable::method(@params);
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

IOStream->method();
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

## Паттерн проектирования singleton

```perl
$a = Some::Singleton->instance;
$b = Some::Singleton->instance;   # same as $a
```

```perl
our $INSTANCE;
sub instance {
    my $class = shift;
    ${ "${class}::INSTANCE" } ||= $class->_new;
}
```

---

# ООП: best practices

* Композиция vs наследование
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
package SuperMan;
extends 'Person';
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

sub _build_fh           { open(file_name) }
sub _build_file_content { read(fh) }
sub _build_xml_document { parse(file_content) }
sub _build_data         { find(xml_document) }
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

---

# Домашнее задание

https://github.com/Nikolo/Technosfera-perl/

`/homeworks/oop_reducer`

Требуется написать классы для проведения над логами операции [схлопывания](https://en.wikipedia.org/wiki/Fold_(higher-order_function)) (reduce).

---

class:lastpage title

# Спасибо за внимание!

## Оставьте отзыв

.teacher[![teacher]()]
