class:firstpage, title

# Программирование на Perl

## Расширенный синтаксис

---
class:note_and_mark title

# Отметьтесь на портале!

---
class: center, middle

# TIMTOWTDI

##There’s More Than One Way To Do It

---
layout:false
# Содержание

* **Сложные структуры данных**
    - Вложенные структуры
    - Символические ссылки
    - Массивы массивов
    - Рекурсия
* Функции
    - Контекст
    - Прототипы
    - Стек
    - Lvalue
* Операторы
    - true и false
    - Строки и числа
    - Логические операторы
* Регулярные выражения
    - введение
* Юникод

---

# Recall

```perl
my `@`array = `(` 4, 8, 15, 16, 23, 42 `)`;
my `%`hash  = `(` k1 => "v1", k2 => v2 `)`;

say `$`array[3]; # 15
say `$`hash{k1}; # v1

my `$`aref  = `[` 4, 8, 15, 16, 23, 42 `]`;
my `$`href  = `{` k1 => "v1", k2 => v2 `}`;

say `$`aref`->`[3];  # 15
say `$`href`->`{k1}; # v1

say ref $aref; # ARRAY
say ref $href; # HASH
```

---
# Сложные структуры

```perl
$var = 7;
%hash = (
    s => "string",
    a => [ qw(some elements) ],  # ARRAY REF
    h => {                       # HASH REF
        nested => "value",
        "key\0" => [ 1,2,$var ], # ARRAY REF
    },
    f => sub { say "ok:@_"; },   # ANON SUB
);

say $hash{s};                 # string
say $hash{a}->[1];            # elements
say $hash{a}[1];              # elements
say $hash{h}`->`{"key\0"}`->`[2]; # 7
say $hash{h}` `{"key\0"}` `[2];   # 7
$hash{f}->(3);                # ok:3
```

---
# Сложные структуры

```perl
$var = 7;
`$`href = `{`
    s => "string",
    a => [ qw(some elements) ],
    h => {
        nested => "value",
        "key\0" => [ 1,2,$var ],
    },
    f => sub { say "ok:@_"; }, 
`}`;

say $href`->`{s};                 # string
say $href`->`{a}->[1];            # elements
say $href`->`{a}[1];              # elements
say $href`->`{h}`->`{"key\0"}`->`[2]; # 7
say $href`->`{h}` `{"key\0"}` `[2];     # 7
$href->{f}->(3);                # ok:3
```


---
# HASH != HASHREF

.not[
```perl
$, = ", "; # $OUTPUT_FIELD_SEPARATOR
@array = (1,2,3);
say @array; # 1, 2, 3

*@array = [1,2,3];
say @array; # ARRAY(0x7fcd02821d38)

%hash  = (key => "value");
say %hash; # key, value

*%hash  = {key => "value"};
say %hash; # HASH(0x7fbbd90052f0), 

*%hash = ( key1 => (1,2), key2 => (3,4) );
say $hash{key1}; # 1
say $hash{key2}; # undef
say $hash{2};    # key2
%hash = ( key1 => 1,2 => 'key2', 3 => 4 );
```
]

---
# Автооживление (autovivification)

```perl
$href = {
    s => "string",
};

$href->{none}{key} = "exists";
say $href->{none};      # HASH(0x7fea...)
say $href->{none}{key}; # exists

$href->{ary}[7] = "seven";
say $href->{ary};       # ARRAY(0x7f9...)
say $href->{ary}[7];    # seven
say $#{ $href->{ary} }; # 7
```

---
# Автооживление (autovivification)

```perl
$href = {
    s => "string",
};

$href->{none}{key} = "exists";
say $href->{none};      # HASH(0x7fea...)
say $href->{none}{key}; # exists

$href->{ary}[7] = "seven";
say $href->{ary};       # ARRAY(0x7f9...)
say $href->{ary}[7];    # seven
say $#{ $href->{ary} }; # 7

$href->{s}{error} = "what?";
say $href->{s}{error};  # what?

say $string{error};     # what?
```

---
# Автооживление (autovivification)

.not[
```perl
$href = {
    s => "string",
};

$href->{none}{key} = "exists";
say $href->{none};      # HASH(0x7fea...)
say $href->{none}{key}; # exists

$href->{ary}[7] = "seven";
say $href->{ary};       # ARRAY(0x7f9...)
say $href->{ary}[7];    # seven
say $#{ $href->{ary} }; # 7

*$href->{s}{error} = "what?";
*say $href->{s}{error};  # what?

*say $string{error};     # what?
```
]
---

.center[
![center-aligned image]( what.jpg )
]

---
layout: false
# Символические ссылки
> Переменная, чьё значение является именем другой переменной

```perl
$name = "var";
$$name = 1;     # устанавливает $var в 1
${$name} = 2;   # устанавливает $var в 2
@$name = (3,4); # устанавливает @var в (3,4)

$name->{key} = 7; # создаёт %var и
                  # устанавливает $var{key}=7

$name->();      # вызывает функцию var
```

---
# Символические ссылки
> `use strict 'refs'` запрещает их использование

```perl
use strict 'refs';

${ bareword }    # ≡ $bareword; # ok
*${ "bareword" }; # not ok

$hash{ key1 }{ key2 }{ key3 };       # ok
$hash{ "key1" }{ "key2" }{ "key3" }; # also ok

$hash{shift};     # no call to shift
$hash{ +shift };  # call is done
$hash{ shift() }; # or so

```

---

# Массивы массивов

```perl
my @array = (1,2,3);
```

--

```perl
my @AofA = (
    [1,2,3],
    [4,5,6],
    [7,8,9],
);
```

--

```perl
my @AofAofA = (
    [ [1,2,3], [4,5,6], [7,8,9] ],
    [ [0,1,2], [3,4,5], [6,7,8] ],
    [ [9,0,1], [2,3,4], [5,6,7] ],
);
```

---

# Массивы массивов

```perl
my $array = [1,2,3];
```

```perl
my $AofA = [
    [1,2,3],
    [4,5,6],
    [7,8,9],
];
```

```perl
my $AofAofA = [
    [ [1,2,3], [4,5,6], [7,8,9] ],
    [ [0,1,2], [3,4,5], [6,7,8] ],
    [ [9,0,1], [2,3,4], [5,6,7] ],
];
```

---
# Массивы массивов

```perl
say $array[0];    # 1

say $AofA[0];     # ARRAY(0x...)
say $AofA[0][0];  # 1

say $AofAofA[0];        # ARRAY(0x...)
say $AofAofA[0][0];     # ARRAY(0x...)
say $AofAofA[0][0][0];  # 1
```

--

```perl
say $array->[0];    # 1

say $AofA->[0];     # ARRAY(0x...)
say $AofA->[0][0];  # 1

say $AofAofA->[0];        # ARRAY(0x...)
say $AofAofA->[0][0];     # ARRAY(0x...)
say $AofAofA->[0][0][0];  # 1
```

---

# Манипуляции

```perl
say scalar @{ $AofA[0] }; # 3
say $#{ $AofA[0] }; # 2

push @{ $AofA[0] }, 4;
shift @{ $AofA[0] };

# cleanup
@{ $AofA[1] } = (); # make empty
$AofA[1] = [];      # create new

for my $row ( @AofA ) {
    say ref $row; # ARRAY
    say join ", ", @$row;
}
```

---

.small14[
```perl
{
    'playlist' => {
        'id'   => '167759395430',
        'name' => 'Nirvana',
        'tagList' => [
            {
                'name' => 'grunge',
                'id' => 220044
            },
            {
                'name' => 'rock',
                'id' => 295024
            }
        ],   
        'counts' => { 
            'play' => 1499,
            'tracks' => 20
        },
        'owner' => { 
            'id' => 255670890,
            'name' => {
                'first' => "Василий",
                'last' => "Иванов"
            },
            'music' => { 
                'count' => {
                    'playlists' => 41,
                    'tracks' => 3171
                },
                'isModerator' => 0,
            },   
        }    
    }    
};
```
]

---

# Examine

```perl
my $complex_structure = ...;

use Data::Dumper;
print Dumper $complex_structure;

local $Data::Dumper::Maxdepth = 1;
local $Data::Dumper::Sortkeys = 1;

print Dumper $complex_structure;

use DDP;
p $complex_structure;
```

---

# Sort

```perl
my @list = (
    { name => "Dean", year => 1979 },
    { name => "Sam",  year => 1983 },
    { name => "John", year => 1954 },
    { name => "Mary", year => 1954 },
);

my @sorted = sort {
    $a->{year} <=> $b->{year}
    ||
    $a->{name} cmp $b->{name}
} @list;

for (@sorted) {
    say "$_->{name} ($_->{year})";
}
```

---

```perl
my @pic = (
    [ { r=>123, g=>127, b=>27 }, ...  ],
    [ { r=>99, g=>255, b=>127 }, ...  ],
    ...
);
my @gray = map { # $_ is a row
    [
        map { # $_ is a cell
            int(($_->{r}+$_->{g}+$_->{b})/3)
        } @$_
    ];
} @pic;

say Dumper \@gray;
[
    [ 92, ... ],
    [ 160, ...],
    ...
]
```

---

```perl
sub dumper; sub dumper {
    my $what = shift; my $depth = shift || 0;
    if (my $ref = ref $what) {
        if ($ref eq 'ARRAY') {
            say "  "x$depth,"-";
            dumper($_,$depth+1) for @$what;
        }
        elsif ($ref eq 'HASH') {
            while (my ($k,$v) = each %$what) {
                say "  "x$depth,"$k:";
                dumper($v,$depth+1);
            }
        }
        else { die "unsupported: $ref"; }
    }
    else {
        say "  "x$depth,$what;
    }
}
```

---

# sample

```perl
-
  -
    g:
      127
    r:
      123
    b:
      27
  -
    g:
      255
    r:
      99
    b:
      127
```


---

# Содержание

---

# Context: wantarray
```perl
sub math {
    my ($x,$y) = @_;

    if (`wantarray`) {
        # called in list context
        return $x + $y, $x - $y; # LIST
    }
    elsif (`defined wantarray`) {
        # wantarray is false, but defined
        # scalar context
        return $x + $y; # SCALAR
    }
    else {
        # void context, no result
        return;
    }
}
```

---

# Context: wantarray

```perl
sub test () {
    return wantarray ? "list" :
    defined wantarray ? "scalar" :
    "void";
}

my `@`x   = test; # list
my `(`$x`)` = test; # list
`say` test;       # list

my `$`y = test    # scalar
say `scalar` test # scalar
1 `+` test        # scalar
if (test) {...} # scalar

test();         # void
```

---

# Prototype: empty & scalar

```perl
sub test() # no args
{ say "@_" };

test(); # ok
test(1); # Too many arguments for main::test

sub test($) # one `scalar` arg
{ say "@_" };

test(1); # ok, 1
test(); # Not enough arguments for main::test

my @a = 1..3;
my %h = (k => 1,x => 2);
test(`@`a); # ok, 3
test(scalar(@a)); # ok, 3
test(%h); # ok, 2/8
```

---

# Prototype: list

```perl
sub test(@); # `list` arg(s)
sub test(%); # also `list` arg(s)

test(); # ok
test(1,2,3); # ok, 1 2 3

my @a = 1..3;
my %h = (k => 1,x => 2);

test(@a); # ok, 1 2 3
test(%h); # ok k 1 x 2
```
---

# Prototype: optional

```perl
sub test($$`;`$); # two mandatory, one optional

test(1); # Not enough arguments for main::test
test(1,2); # ok
test(1,2,3); # ok
test(1,2,3,4); # Too many arguments for main::test

sub test($$`;`@); # two mandatory, any optional
sub test($$@); # two mandatory, any optional
# empty list is also a list

test(1); # Not enough arguments for main::test
test(1,2); # ok
test(1,2,3); # ok
test(1,2,3,4); # ok
test(1,2,3,4,1..100); # ok
# ...
```

---

# Prototype: optional

```perl
sub test(_) # either one arg or $_
{say "@_"};

test(1); # 1
for (1..3) {
    test() # 1, 2, 3
}

say prototype \&CORE::ord; # _
say prototype \&CORE::chr; # _
say prototype \&CORE::length; # _
say prototype \&CORE::ucfirst; # _
# ...

```

---

# Prototype: force type

```perl
my $s = "";
my @a = 1..3;
my %h = (k => 1,x => 2);

sub test(\@); # Force ARRAY

test(@a); # ok, ARRAY(0x7fe55901f3c0)

test(%h); # Type of arg 1 to main::test must
          # be array (not private hash)
test(1); # Type of arg 1 to main::test must
         # be array (not constant item)
test($s); # Type of arg 1 to main::test must
         # be array (not private variable)
```

---

# Prototype: force type

```perl
my $s = "";
my @a = 1..3;
my %h = (k => 1,x => 2);

sub test(\%); # Force HASH

test(@a); # Type of arg 1 to main::test must
          # be hash (not private array)
test(%h); # ok, HASH(0x7fa02402d328)

test(1); # Type of arg 1 to main::test must
         # be hash (not constant item)
test($s); # Type of arg 1 to main::test must
         # be hash (not private variable)
```

---

# Prototype: force type

```perl
my $s = "";
my @a = 1..3;
my %h = (k => 1,x => 2);

sub test(\$); # Force SCALAR

test(@a); # Type of arg 1 to main::test must
          # be scalar (not private array)
test(%h); # Type of arg 1 to main::test must
          # be scalar (not private hash)
test(1); # Type of arg 1 to main::test must
         # be scalar (not constant item)
test($s); # ok, SCALAR(0x7ff034831c90)
```

---

# Prototype: force type

```perl
my $s = "";
my @a = 1..3;
my %h = (k => 1,x => 2);

sub test (\[@%$]); # Any of ARRAY, HASH, SCALAR

test(@a); # ok, ARRAY(0x7f827a029008)
          # 
test(%h); # ok, HASH(0x7f827a029128)
          # 
test(1); # Type of arg 1 to main::test must
         # be one of [@%$] (not constant item)
test($s); # ok, SCALAR(0x7f827a022ce0)

```

---

# Prototype: force type

```perl
sub mypush(\@;@) {
    my $ref = shift;
    my $offset = $#$ref+1;
    for my $i (0..$#_) {
        $ref->[$offset + $i] = $_[ $i ];
    }
}

sub mypop(\@) {
    my $ref = shift;
    my $val = $ref->[-1];
    $#$ref = $#$ref-1;
    return $val;
}
```

---

# Prototype: code block

```perl
sub mymap(&@) {
    my $code = shift;
    my @r;
    push @r, $code->() for @_;
    @r;
}

sub mygrep(&@) {
    my $code = shift;
    my @r;
    push @r, $_ if $code->() for @_;
    @r;
}

say mymap { $_+2 } 1..5; # 3,4,5,6,7
say mygrep { $_ % 2 } 1..5; # 1,3,5
```

---

```perl
# Why
say reverse 'dog';
# prints "dog", but
say ucfirst reverse 'dog';
# prints "God"?
```

--

```perl
say reverse "dog", "cat"; # cat dog;
say scalar reverse "dog"; # god;
say scalar reverse "dog", "cat"; # tac god;

say prototype \&CORE::ucfirst; # _

# ucfirst(...)
# -> ucfirst(scalar(...))
#   -> ucfirst(scalar(reverse("dog")))

# dog -> god -> God
```

---

# Prototype: constants

```sh
perl -MO=Deparse -E 'sub test { 1 }; say test()'
use feature ...,'say',...;
sub test { 1; }
say test();
```

```sh
perl -MO=Deparse -E 'sub test`()`{ `1` }; say test()'
*sub test () { 1; }
use feature ...,'say',...;
say 1;
```

```sh
perl -MO=Deparse -E 'sub test(){ 0 }; say if test'
sub test () { 0; }
use feature ...,'say',...;
*'???';
```

---

# Подавление прототипа

```perl
sub test($;$$$) { say @_ }

sub mytest($;$$$) {
    my @args = @_;
    test(@args);
}
mytest(1,3,5,7); # 4

sub mytest($;$$$) {
    my @args = @_;
    `&`test(@args);
}
mytest(1,3,5,7); # 1 3 5 7

test(); # Not enough arguments for main::test
`&`test(); # ok
```

---

# Вызов с чужими параметрами

```perl
sub test { say "@_"; shift; }
sub mytest {
    &test; # <- no ()
    say "@_";
}

mytest(1,2,3,4); # 1 2 3 4
                 # 2 3 4

my $anon = sub { say "@_"; pop; };
sub callanon {
    &$anon; # <- no ()
    say "@_";
}

callanon(1,2,3,4); # 1 2 3 4
                   # 1 2 3 
```

---
class:center, middle

# \_\_END\_\_

---
class:lastpage title

# Спасибо за внимание!

## Оставьте отзыв

.teacher[![teacher]()]
















