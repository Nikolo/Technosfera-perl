class:firstpage

# ООП

---

class:note_and_mark title

# Отметьтесь на портале!

---

class: center, middle

# Термины

---

# Объект, метод

```ruby
> a = [5, 3, 7]
=> [5, 3, 7]

> a.length()
=> 3

> a.max()
=> 7
```

---

# Класс, конструктор, атрибут

```python
class Person():
  def __init__(self, name):
    self.name = name

vadim = Person("Vadim")
katya = Person("Katya")

puts vadim.name # Vadim

# def = sub
```

---

# Наследование

```python
class Student(Person):
  def get_name(self):
    return self.name


class Teacher(Person):
  def get_name(self):
    return 'Профессор ' + self.name

Teacher('Иван').get_name() # Профессор Иван

# def = sub
```

---

class:middle, center

# `package` + `ref` = объект

---

# bless

```perl
{
  package Package::Name;
  #...
}

my $obj = bless {}, 'Package::Name';

my $obj2 = bless [], '...';
my $scalar = 42;
my $obj2 = bless \$scalar, '...';
```

---

# Методы

```perl
{
  package Person;
  sub set_name {
    my ($self, $name) = @_;
    $self->{name} = $name;
  }
  sub get_name {
    my ($self) = @_;
    return $self->{name};
  }
}

my $vadim = bless {}, 'Person';
$vadim->set_name('Vadim');
# SuperPerson::set_name($vadim, 'Vadim');
print $vadim->get_name(); # Vadim
```

---

# Атрибуты?

```perl
my $vadim = bless {
    name => 'Vadim',
    zzz => 42,
}, 'Person';

print $vadim->{name}; # Vadim
print $vadim->{zzz}; # 42
```


```perl
sub get_name {
  my ($self) = @_;

  return $self->{name};
}
```

---

# Методы класса

```perl
package Person;

sub class_name {
  my ($class) = @_;

  return $class;
}

Person->class_name(); # Person 
# SuperPerson::class_name('Person');
```

---

# `$self`, `$class`

```perl
sub object_method {
    my ($self) = @_;
}

sub class_method {
    my ($class) = @_;
}
```

---

# Конструктор?

```perl
{
  package Person;

  sub new {
    my ($class, $name) = @_;
    return bless {name => $name}, $class;
  }

  sub get_name {
    my ($self) = @_;
    return $self->{name};
  }
}

my $vadim = Person->new('Vadim');
print $vadim->get_name(); # Vadim
```

---

# Универсальный конструктор

```perl
package Object;

sub new {
  my ($class, @params) = @_;

  my $obj = bless {}, $class;
  $obj->init(@params);

  return $obj;
}

sub init {
  my ($self, %params) = @_;

  $self->{$_} = $params->{$_} for keys %params;

  return;
}
```

---

# Универсальный конструктор в деле

```perl
package Person;

# Наследуемся от Object

sub init {
  my ($self, $age) = @_;

  die "Negative age $age" if $age < 0;

  $self->{age} = $age;

  return;
}

Person->new(42);
```

---

# Методы: еще варианты o_O

```perl
my $class = 'A';
$class->new();

my $method_name = $cond ? 'get_a' : 'get_b';
$obj->$method_name;

A::new(); # not the same! static?

$obj->A::get_a(); # !?
# SuperA::get_a($obj);

```

---

# Методы: indirect :(

```perl
new My::Class(1, 2, 3);

My::Class->new(1, 2, 3);
```

```perl
foo $obj(123); # $obj->foo(123);
```

```perl
use strict;
use warnings;

Syntax error!

exit 0;
```

---

# Методы: WHY!?

```perl
use strict;
use warnings;

Syntax error!

exit 0;
```

```perl
use warnings;
use strict;
'error'->Syntax(!exit(0));
```

---

# can

```perl
{
  package A;

  sub test {
    return 42;
  }
}

if (A->can('test')) {
  print A->test;
}

print A->can('test')->('A');
```

```perl
my $obj = bless {}, 'A';
$obj->can('test');
```

---

# Filehandles

```perl
open(my $fh, '>', 'path/to/file');

$fh->autoflush();
$fh->print('content');

STDOUT->autoflush();
```

```perl
print $fh "test\n";
```

---

# Пакеты

```perl
use Some::Package qw(a b c);
# Some::Package->import(qw(a b c));

no Some::Package;
# Some::Package->unimport;

use Some::Package 10.01
# Some::Package->VERSION(10.01);

```

---

# Итого

```perl
my $vadim = Person->new('Vadim');

print $vadim->get_name();

print $vadim->{name};

$vadim->can('get_name')->();

$fh->print(123);

$katya = new Person(); # :(
```

---

class: middle, center

# Примеры

---

# DBI

```perl
$dbh = DBI->connect(
  $data_source,
  $username,
  $auth,
  \%attr
);

my $sth = $dbh->prepare('SELECT name FROM city');
$sth->execute();
```

---

# XML::LibXML;

```perl
use XML::LibXML;

my $document = XML::LibXML->load_xml(
    string => '...'
);

my $list = $document->findnodes('...');
    # XML::LibXML::NodeList
```

```perl
       XML::LibXML::Node
      /                 \
 XML::LibXML::Document  XML::LibXML::Element
```

---

# File::Spec

```perl
use File::Spec;

print File::Spec->catfile('a', 'b', 'c');
```

---

# JSON

```perl
use JSON;

JSON->new->utf8->decode('...');

decode_json '...';
```

---

class: center, middle

# Наследование

---

# Наследование

```perl
{
  package IOStream;

  BEGIN { push(@ISA, 'InStream', 'OutStream') }
  use base qw(InStream OutStream);
  use parent qw(InStream OutStream);
}

```

---

# UNIVERSAL

```perl
$teacher->can('get_name');

$teacher->isa('Person');
Teacher->isa('Person');

Teacher->VERSION(5.12);
```

---

# SUPER

```perl
package Teacher;

sub get_name {
  my ($self, %params) = @_;

  my $name = $self->SUPER::get_name(%params);

  return "Уважаемый $name";
}
```

---

class: center, middle

# Method Resolution Order

---

# Method Resolution Order

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

qw(
  IOStream InStream Stream Object
  CacheableOutStream Cacheable
);
```

---

# mro

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

qw(
  IOStream InStream CacheableOutStream
  Stream Object Cacheable
);
```

---

# mro — next::method

```perl
package Teacher;
use mro;

sub get_name {
  my ($self, %params) = @_;

  my $name = $self->next::method(%params);

  return "Уважаемый $name";
}
```

---

# Итого

```perl
@ISA;

use base;
use parent;

UNIVERSAL;
SUPER;

use mro;
use mro 'c3';
$obj->next::method();
```

---

class: center, middle

# MOAR

---

# `ref`, `blessed`

```perl
use JSON:
use Scalar::Util 'blessed';

ref JSON->new(); # 'JSON'
ref [];          # 'ARRAY'
ref {};          # 'HASH'
ref 0;           # ''

blessed JSON->new(); # 'JSON'
blessed [];          # undef
blessed {};          # undef
blessed 0;           # undef
```

---

# AUTOLOAD

```perl
package A;
our $AUTOLOAD;
sub AUTOLOAD { print $AUTOLOAD }
```

```perl
A->new()->test(); # test
A->can('anything'); # :(
```

```perl
sub UNIVERSAL::AUTOLOAD {}

# Dog->m(); Animal->m(); UNIVERSAL->m();
# Dog->AUTOLOAD(); Animal->AUTOLOAD();
# UNIVERSAL->AUTOLOAD();
```

---

# DESTROY

```perl
package Teacher;

sub DESTROY {
  my ($self) = @_;
  
  $self->_flush_all_grades();
}
```

```perl
{
  my $teacher = Teacher->new();
  $teacher->grade($student1, 5);
  # ...
}
```

---

# DESTROY — сложности

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

# Исключения ¯\\\_(ツ)\_/¯

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
  }
  else {
    die $error;
  }
};
```

---

# Исключения — модули

```perl
use Try::Tiny;
try { die 'foo' }
catch { warn "caught error: $_"; }; # not $@
```

```perl
use Error qw(:try);
try {
  throw Error::Simple 'Oops!';
}
catch Error::Simple with { say 'Simple' }
catch Error::IO     with { say 'IO' }
except                   { say 'Except' }
otherwise                { say 'Otherwise' }
finally                  { say 'Finally' };
```

---

# ???

```perl
$hash{x} = 7;

print $hash{x};
```

---

class:middle, center

# 42

---

# tie

```perl
package Local::MyHash;

use Tie::Hash;
use base 'Tie::StdHash';

sub FETCH { 42 }
```

```perl
my %hash;
tie %hash, 'Local::MyHash';

$hash{x} = 7;

print $hash{x};
```

---

# overload

```perl
my $x = Local::Int->new(42);
my $y = Local::Int->new(24);

print(($x + $y)->{value}); # 66
```

---

# overload

```perl
package Local::Int;

use overload '+' => 'add';

sub new {
    my ($class, $value) = @_;
    return bless {value => $value}, $class;
}

sub add {
    my ($self, $other) = @_;

    return __PACKAGE__->new(
        $self->{value} + $other->{value}
    );
}
```

---

# Class::Accessor

```perl
package Foo;
use base qw(Class::Accessor);
Foo->follow_best_practice;
Foo->mk_accessors(qw(name role salary));
```

```perl
use base qw(Class::Accessor::Fast);
use base qw(Class::XSAccessor);
```

---

# Итого
```perl
ref($obj);

blessed($obj);

A->brr();

{ A->new() }

die A->new();

$h->{42};

A->new() + A->new();
```

---

class: middle, center

# Moose и его друзья

---

# Moose

```perl
package Person;

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
Person->new(
  first_name => 'Vadim',
  last_name  => 'Pushtaev',
);
```

---

# Moose — наследование

```perl
package User;

use Moose;

extends 'Person';

has password => (
  is => 'ro',
  isa => 'Str',
);
```

---

# Moose — инициализация
### BUILD

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

# Moose — инициализация
### default

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

# Moose — инициализация
### builder

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

# Moose — инициализация
### Цепочки

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

# Moose — миксины

```perl
with 'Role::HasPassword';
```

```perl
package Role::HasPassword;
use Moose::Role;
use Some::Digest;

has password => (
  is => 'ro',
  isa => 'Str',
);

sub password_digest {
  my ($self) = @_;

  return Some::Digest->new($self->password);
}
```

---

# Moose — делегирование

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

```perl
{
  handles => qr/^get_(a|b|c)|set_(a|d|e)$/,
  handles => 'Role::Name',
}
```

---

# Moose — и т. д. :D

```perl
before 'is_adult' => sub { shift->recalculate_age }
```

```perl
subtype 'ModernDateTime'
  => as 'DateTime'
  => where { $_->year() >= 1980 }
  => message { 'The date is not modern enough' };

has 'valid_dates' => (
  is  => 'ro',
  isa => 'ArrayRef[DateTime]',
);
```

```perl
package Config;
use MooseX::Singleton; # instead of Moose
has 'cache_dir' => ( ... );
```

---

# Moose — аналоги

* Moose
* Mouse
* Moo
* Mo
* M

---

# ДЗ

https://github.com/Nikolo/Technosfera-perl/

`/homeworks/oop_reducer`
