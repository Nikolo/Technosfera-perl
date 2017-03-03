class:firstpage, title

# Программирование на Perl

## Основы синтаксиса

---
class:note_and_mark title

# Отметьтесь на портале!

---
class: center, middle

# TIMTOWTDI

##There’s More Than One Way To Do It

---
class: center, middle

# The only thing can parse
# **Perl** (the language) is
# **perl** (the binary)

---

class: center, middle

## Perl should only be studied as a second language.
## A good first language would be English.
.right[
>Larry Wall
]
---
layout:false
# Содержание

* **Структуры данных**
    - Массивы
    - Хэши
    - Ссылки
* Функции для работы со списками
* Управление циклами
* Постфиксная запись
* Интерполяция в строках
* Функции
    - Декларация
    - Аргументы
    - Использование

---
layout:true
# Переменные

---

* SCALAR
    - Number
    - String
    - Reference
* ARRAY
    - Of scalars
* HASH
    - Key: string
    - Value: scalar

---

* SCALAR (`$s`)
    - Number
    - String
    - Reference
* ARRAY (`@a`)
    - Of scalars
* HASH (`%h`)
    - Key: string
    - Value: scalar

---

* SCALAR (`$s`)
    - Number
        + Integer value (`$s = 1`)
        + Numeric value (double) (`$s = 3.14`)
    - String (`$s = "str"`)
    - Reference (`$r`)
        + Scalar (`$$r`)
        + Array (`@$r`)
        + Hash (`%$r`)
        + Function (`&$r`)
        + Filehandle (`*$r`)
        + Lvalue (`$$r`)
        + Reference (`$$r`)
* ARRAY (`@a`)
* HASH (`%h`)

---
layout:true
# SCALARs

---

## Числа
```perl
my $int         = 12345;
my $pi          = 3.141592;
my $pi_readable = 3.14_15_92_65_35_89;
my $plank       = .6626E-33;
my $hex         = 0xFEFF;
my $bom         = 0xef_bb_bf;
my $octal       = 0751;
my $binary      = 0b10010011;
```

---

## Строки
```perl
my $one    = "string";
my $two    = 'quoted';
my $wrap   = "wrapped
           string";
my $join   = "prefix:$one\r\n";

my $q_1    = q/single-'quoted'/;
my $qq_2   = qq(double-"quoted"-$two);
my $smile  = ":) -> \x{263A}";

my $here   = <<END;
some data
END

my $ver    = v1.2.3.599;
```

---
layout:false

# ARRAYs: создание

```perl
my @av1 = (4,8,15,16,23,42);
my @av2 = ('q','w','e');
my @av2 = (1,2,3,'q','w','e');
my @digits = 0..9;

my @simple = qw(a b c); # ('a','b','c')

my @array = (1,2,3,@simple,4,5);
my @array = (1,2,3,'a','b','c',4,5);

my $aref = \@array; # take ref
my $aref = [1,2,3,@simple,4,5]; # anon ref

my $aref = [@array]; # copy + anon ref
my $aref = [ (@array) ]; # av->list, list->aref
```

.footer[[Array vs list](http://friedo.com/blog/2013/07/arrays-vs-lists-in-perl)]

---

# ARRAYs: обращение

```perl
`$`ARRAY[ `SCALAR` ]: `SCALAR`
```

```perl
my @array = (1,2,3,'a','b','c',4,5);
my $aref = \@array;

say `$`array[3];    # a
say ${array}[3];  # a
say ${array[3]};  # a

say "last elt = ", `$#`array; # 7
say "length   = ", scalar `@`array; # 8

say $aref->[3]; 
say ${$aref}[3];
say "last elt = ", `$#`$aref;
say "last elt = ", `$#{`$aref`}`;
say "length   = ", scalar `@{`$aref`}`;
```

---

# ARRAYs: обращение

```perl
`$`ARRAY[ `SCALAR` ] = `SCALAR`
```

```perl
my @array = ();
my @array;      # better

$array[0] = 1;
$array[1] = 2;
$array[7] = 5;

say $#array; # 7
say $array[`-1`]; # 5

use Data::Dumper;
say Dumper \@array;
# [1,2,undef,undef,undef,undef,undef,5]
use DDP;
p @array;
```

---

# ARRAYs: срезы

```perl
`@`ARRAY[ `LIST` ]: `LIST`
```

```perl
my @array = (4,8,15,16,23,42);
$aref = \@array;

say join ",", `@`array[0,2,4]; # 4,15,23
say join ",", `@{`array`}`[0,2,4]; # 4,15,23
say join ",", `@`array[0..2]; # 4,8,15

say join ",", @$aref[0,2,4]; # 4,15,23
say join ",", @{ $aref }[0,2,4]; # 4,15,23

@array[5..7] = (10,20,30);
say join ",", @array; # 4,8,15,16,23,10,20,30
```

---
class:center

# ARRAY

![image]( perlarray.svg )

---

# ARRAY ops: push, pop, shift, unshift

.left[
```perl
my @a;
push @a, 1;
push @a, 2,3,4;
my $x = pop @a;
my $x = shift @a;
unshift @a, 7,8;
```
]
.right[
```perl
# @a = ()
# @a = (1)
# @a = (1,2,3,4)
# @a = (1,2,3), $x = 4
# @a = (2,3), $x = 1
# @a = (7,8,2,3)
```
]

```perl
my @a =      ( 1, 2, 3, 4, 5, 6, 7 );
#   │             └────┬┘
#   │             └─┐  │     ┌ replacement
#   └───────────┐   │  │  ┌──┴───┐
my @b = splice( @a, 1, 3, ( 8, 9 ) );
say @a; # 1, 8, 9, 5, 6, 7
say @b; # 2, 3, 4
```

---

# ARRAY ops: for

```perl
my @a = (4,8,15,16,23,42);
```

## Не делайте так:
.not[
```perl
*for (my $i; $i <= $#a; $i++) { ... }
*for (my $i; $i < @a; $i++) { ... }
```
]

> Почему? C-style. Если нужен индекс:

```perl
for my $i (0..$#a) { ... }
```

> Если нужны только значения:

```perl
for my $var (@a) { ... }
```

---

# ARRAY ops: for

```perl
my @array = (4,8,15,16,23,42);
```
.left[
```perl
`for` (@array) {
    say $_;
}
```
]
.right[
```perl
`foreach` (@array) {
    say $_;
}
```
]
.center[
## for ≡ foreach
]
.left[
```perl
for `my $val` (@array) {
    say $val;

    `$val`++;
}
say "@array";
```
]
.right[
```perl
4
8
15
16
23
42
`5 9 16 17 24 43`
```
]

---

# ARRAY ops: while each

```perl
my @array = (4,8,15,16,23,42);

while (my ($i,$v) = `each` @array) {
    say "$i: $v";                    # 0: 4
    $v++;                            # 1: 8
}                                    # 2: 15
                                     # 3: 16
say "@array";                        # 4: 23
# 4 8 15 16 23 42                    # 5: 42
```

---

# HASHes: создание

```perl
my %first = (
    key1 => "value1",
    key2 => "value2",
);
my %second = (
    'key3', "value3",
    'key4', "value4",
);
my %third = qw(key5 value5 key6 value6);
my %all = (%first, %second, %third);

my $href = \%hash;
my $href = {
    key1 => "value1",
    key2 => "value2",
};
```

---

# HASHes: создание

```perl
my `%`hash = `(`
    key1 => "value1",
    key2 => "value2",
`)`;

my `$`href = `{`
    key1 => "value1",
    key2 => "value2",
`}`;
```

---

# HASHes: создание

```perl
my @array = qw(key1 val1 key2 val2);

my %hash = @array;

use Data::Dumper;
say Dumper \%hash;

# {
#    key1 => "val1",
#    key2 => "val2",
# }

my $aref = [qw(key1 val1 key2 val2)];
my %hash = `@{`$aref`}`;

my $hashref = { @array };
my $hashref = { `@{`$aref`}` };
```

---

# HASHes: использование

```perl
`$`HASH{ `SCALAR` }: `SCALAR`
`$`HASH{ `BAREWORD` }: `SCALAR`
```

```perl
my %hash = (key1 => "value1", key2 => "value2");
my $href = {key1 => "value1", key2 => "value2"};
my $key = "key2";

say $hash{"key2"}; # value2
say $hash{ key2 }; # value2
say $hash{ $key }; # value2

say $href->{"key2"};
say $href->{ key2 };
say $href->{ $key };
say `${`$href`}`{ key2 };

```

---

# HASHes: использование

```perl
`$`HASH{ `SCALAR` } = `SCALAR`
`$`HASH{ `BAREWORD` } = `SCALAR`
```

```perl
my %hash;
my $href = {};
$hash{ key1 } = "value1";
$hash{ key2 } = "value2";
$href->{ key1 } = "value1";
$href->{ key2 } = "value2";
`${`$href`}`{ key3 } = "value3";

say Dumper \%hash;
# {
#    key1 => "val1",
#    key2 => "val2",
# }
```

---

# HASHes: использование

```perl
my %simple = qw(k1 1 k2 2);
my %hash = (key3 => 3, key4 => "four", %simple);
my $key = "key3";

say join ",", %simple; # k2,2,k1,1
say join ",", %simple; # k1,1,k2,2

say join ",", `keys`   %hash; # k2,key3,k1,key4
say join ",", `values` %hash; # 2, 3,   1, four

say join ",", `@`hash`{` "k1", $key `}`; # 1,3

my $one = `delete` $hash{k1}; say $one; # 1
say $hash{k2} if `exists` $hash{k2}; # 2
```

---

![image]( perlhash.svg )

---

# HASH ops: while/each

```perl
my %hash = (key1 => "value1", key2 => "value2");

while (my ($k,$v) = each %hash) {
    say "$k: $v";
}
```

.f-right[
# ⚠
]

> Итератор прикреплён к переменной.<br>Обращение к `keys`, `values` сбивает итератор

.clear[]

.not[
```perl
while (my ($k,$v) = each %hash) {
*   my @keys = `keys` %hash;
    say "$k in (@keys)";
}
```
]

> Данная программа будет выполняться в бесконечном цикле

---

# HASH ops: for, keys, values

```perl
my %hash = ( key1 => "value1",
    key2 => "value2", key3 => "value3");

for my $key (keys %hash) {
    say $key;          # key2   key1   key3
    say $hash{$key};   # value2 value1 value3
}
for `my $value` (values %hash) {
    say $value;        # value2 value1 value3
    $value .= "+1";
}

p %hash;
#    key1   "value1`+1`"
#    key2   "value2`+1`"
#    key3   "value3`+1`"

```

---
class:center

# ARRAY & HASH

![image]( perldata.svg )

---

# Ссылки

```perl
my $scalar_ref = \$scalar;       # SCALAR
my $array_ref  = \@array;        # ARRAY
my $hash_ref   = \%hash;         # HASH
my $code_ref   = \&function;     # CODE
my $glob_ref   = \*FH;           # GLOB
my $ref_ref    = \$scalar_ref;   # REF

my $array_ref  = [ 4,8,15,16 ];
my $hash_ref   = { one => 1, two => 2 };
my $code_ref   = sub { ... };

my ($one,$two) = (\"one",\"two");
my ($one,$two) = \("one","two");
```

---

# ref

.left[
```perl
say ref $scalar;
say ref \$scalar;
say ref \\$scalar;
say ref \@array;
say ref \%hash;
say ref [];
say ref {};
say ref \&main;
say ref sub {};
```
]
.right[
```sh
''
SCALAR
REF
ARRAY
HASH
ARRAY
HASH
CODE
CODE
```
]

```perl
if (ref $val) {
    ...
}
else {
    ...
}
```

---
# Содержание

* Структуры данных
    - Массивы
    - Хэши
    - Ссылки
* **Функции для работы со списками**
* Управление циклами
* Постфиксная запись
* Интерполяция в строках
* Функции
    - Декларация
    - Аргументы
    - Использование

---

# grep

```perl
OUT_LIST = grep { ... } IN_LIST
OUT_LIST = grep `...`, IN_LIST
# ... must return true or false
```

--

```perl
for (IN_LIST) {
    push @OUT_LIST, $_ if ...;
}
return @OUT_LIST
```

--
```perl
my @strings = ('qwe','sdf','','zxc');
my @nonempty = grep { length $_ } @strings;
# qwe sdf zxc
my $count = grep { length $_ } @strings;
# 3
my @odd  = grep {     $_ % 2 } 1..100;
my @even = grep { not $_ % 2 } 1..100;
```

.footer[[grep](http://perldoc.perl.org/functions/grep.html)]

---

# map

```perl
OUT_LIST = map { ... } IN_LIST
OUT_LIST = map `...`, IN_LIST
# ... must return output
```

--

```perl
for (IN_LIST) {
    push @OUT_LIST, ...;
}
return @OUT_LIST
```

--

```perl
my @squares = map { $_**2 } 1..5; # 1,4,9,16,25
say map chr($_), 65..70;          # ABCDEF

my %hash = map { $_ => $_**2 } 1..5;
# { 1 => 1, 2 => 4, 3 => 9, 4 => 16, 5 => 25 }
```

.footer[[map](http://perldoc.perl.org/functions/map.html)]

---

# sort

```perl
OUT_LIST = sort IN_LIST # string sort
OUT_LIST = sort { ... } IN_LIST
`$a`, `$b` # sort vars
`<=>`, `cmp` # comparators
```

--

```perl
@alphabetically = sort @strings;
@nums = sort { $a <=> $b } @numbers;
@rev = sort { $b <=> $a } @numbers;
@ignorecase = sort { fc($a) cmp fc($b) } @strings;

for my $k (sort keys %hash) {
    say "$k: $hash{$k}";
}
```

.footer[[sort](http://perldoc.perl.org/functions/sort.html)]

---

# sort: `cmp` vs `<=>`

```perl
say "x" cmp "y"; # -1, x less than y
say "x" cmp "x"; #  0, x equals to x
say "y" cmp "x"; #  1, y greater than x

say 2 <=> 7; # -1, 2 less than 7
say 5 <=> 5; #  0, 5 equals to 5
say 7 <=> 2; #  1, 7 greater than 2

say "x" <=> "y";  # 0, x equals to y `numerically`
say "2" cmp "10"; # 1, 2 gt than 10 as `strings`

sub smart {
    $a <=> $b # compare as numbers. strings give 0
    ||        # 0 passes to second comparison
    fc($a) cmp fc($b) # compare as strings, CI
}
my @sorted = sort smart @strings;
```

---

# reverse

```perl
my %hash = ( key1 => "value1", key2 => "value2");
my @array = (1..5);
p %hash;
#    key1   "value1"
#    key2   "value2"
p @array;
# 1 2 3 4 5

my %rev_h = reverse %hash;
my @rev_a = reverse @array;
p %rev_h;
#    value1   "key1",
#    value2   "key2"
p @rev_a;
# 5 4 3 2 1
```

.footer[[reverse](http://perldoc.perl.org/functions/reverse.html)]

---

# split & join

```perl
my $string = "Just Another Perl Hacker";
my @letters = split //, $string;
say "@letters";
# J u s t   A n o t h e r   P e r l   H a c k e r
my @words = split / /, $string;
p @words;
# 'Just' 'Another' 'Perl' 'Hacker'

my $one = join "", sort @letters;
say $one;
# AHJPaceeehklnorrrsttu

my $other = join ", ", reverse @words;
say $other;
# 'Hacker, Perl, Another, Just'
```

.footer[[join](http://perldoc.perl.org/functions/join.html)]

---

# List conversions

```perl
my %hash = ( key1 => "val1",
    key2 => "val2", key3 => "val3");
my @array = %hash;
# key2 val2 key1 val1 key3 val3

@array = map { $_, $hash{$_} } sort keys %hash;
# key1 val1 key2 val2 key3 val3

%hash = @array;
#{key1 => "val1", key3 => "val3", key2 => "val2"}
```

---

# unique

```perl
my @with_dups = qw(a b c a e n f a d e a);
my %uniq;
my @unique = grep { !$uniq{$_}++ } @with_dups;    
say "@unique";
# a b c e n f d
p %uniq;
#    a   4,
#    b   1,
#    c   1,
#    d   1,
#    e   2,
#    f   1,
#    n   1,
```

## Also see List::Util

---

# intersection

```perl
my @a = 1..55;
my @b = 45..100;

my %chk;
@chk{@a} = ();
# 1 => undef, 2 => undef, ... 55 => undef

my @common = grep { exists $chk{$_} } @b;

say "@common";
# 45 46 47 48 49 50 51 52 53 54 55
```

---

# exclusion

```perl
my @a = 1..10;
my @odd = grep {$_ % 2} @a; # 1 3 5 7 9

my %odd = map { $_ => 1 } @odd;

my @even = grep { !$odd{ $_ } } @a;

say "@even";
```

---

# min/max

```perl
# take 10 random numbers in range [0,50)
my @a = map { int rand 50 } 1..10;
say "@a";
# 37 32 21 19 49 5 3 37 45 43

my $min = (sort { $a <=> $b } @a)[0];
say $min; # 3

my $max = (sort { $a <=> $b } @a)[-1];
say $max; # 49

my $max = (sort { $b <=> $a } @a)[0];
say $max; # 49

# or use List::Util qw(min max);
```

---

# random, shuffle

```perl
my @a = map { int rand 50 } 1..10;
@a = qw(42 14 2 40 39 15 12 36 23 13);
my @b = sort { $a<=>$b } @a;
say "@a";
# 42 14 2 40 39 15 12 36 23 13
say "@b";
# 2 12 13 14 15 23 36 39 40 42

say "random item: ", @a[ rand @a ]; # 14
say "random item: ", @a[ rand($#a+1) ]; # 36

my @c = sort { int(rand(3))-1 } @b;
say "@c";
# 15 2 14 12 40 23 36 39 13 42
```

---
# Содержание

* Структуры данных
    - Массивы
    - Хэши
    - Ссылки
* Функции для работы со списками
* **Управление циклами**
* Постфиксная запись
* Интерполяция в строках
* Функции
    - Декларация
    - Аргументы
    - Использование

---

# next

```perl
for my $item ( @items ) {
    my $success = prepare($item);

    unless ($success) {
*       next;
    }

    process($item);
} continue {
*   # next переходит сюда
    postcheck($item);
}
```

.footer[[perldoc -f next](http://perldoc.perl.org/functions/next.html)]

???

* `next` Начинает новую итерацию цикла, как `continue` в C.
* Если присутствует блок `continue {}`, то он исполняется даже для пропущенных строк

---

# last

```perl
for my $item ( @items ) {
    my $success = prepare($item);

    unless ($success) {
*       last;
    }

    process($item);
} continue {
    postcheck($item);
}
*# last переходит сюда
```

.footer[[perldoc -f last](http://perldoc.perl.org/functions/last.html)]

???

* `last` прерывает исполнение текущего цикла
* `last` является эквивалентом `break` из языка C
* Даже, если присутствует блок `continue {}`, то он не исполняется

---

# redo

```perl
for my $item ( @items ) {
*   # redo переходит сюда
    my $success = prepare($item);

    unless ($success) {
*       redo;
    }

    process($item);
} continue {
    postcheck($item);
}
```

.footer[[perldoc -f redo](http://perldoc.perl.org/functions/redo.html)]

???

* `redo` начинает итерацию цикла с начала без исполнения блока условия
* `redo` не имеет аналога в языке C
* При наличии блока `continue {}`, он не исполняется

---

# Управление внешним циклом

.left.w70[
```perl
my @outer_array = 1..3;
my @inner_array = 1..3;

`OUTER`:
for my $x (@outer_array) {
    for my $y (@inner_array) {
        next `OUTER` if $y > $x;
        say "$x $y";
    }
} continue {
    # next OUTER jumps here
    say "row ends";
}
```
]
.right.w30[
```perl
1 1
row ends
2 1
2 2
row ends
3 1
3 2
3 3
row ends
```
]

.clear[]

> `next`, `last`, `redo` могут выполнять прыжок по метке, как `goto`

---

# Постфиксная нотация

```perl
STMT if EXPR;
```

```perl
STMT unless EXPR;
```

```perl
STMT while EXPR;
```

```perl
STMT until EXPR;
```

```perl
STMT for LIST;
```

```perl
STMT when EXPR;
```

---

# Примеры

```perl
if ($_ !~ /^#/) { say $_ }
unless (/^#/) { say }
say unless /^#/;
say if !/^#/

do_something() if $most_likely;

for (@loop) {
    last if $enough++ > 10;
}

say for @items;

# etc.
```

---

# Постфиксные циклы

```perl
do {
    ...;
} while ( EXPR );
```

```perl
do {
    ...;
} until ( EXPR );
```

```perl
do {
    ...;
} for ( LIST );
```

---

# Постфиксные циклы

```perl
do {
    ...;
} while ( EXPR );
```

.f-right[
# ⚠
]

* Не работает `next`
* Не работает `last`
* Не работает `redo`
* Нет места для `continue {...}`

--

> Нет обрамляющего блока

--

> Лучше не пользоваться

---

# Содержание

* Структуры данных
    - Массивы
    - Хэши
    - Ссылки
* Функции для работы со списками
* Управление циклами
* Постфиксная запись
* **Интерполяция в строках**
* Функции
    - Декларация
    - Аргументы
    - Использование

---

# Интерполяция

> В "-строках интерполируются `$..` и `@..`

```perl
my $var = "one";
my @ary = (3, "four", 5);
my %hash = (k => "v", x => "y");
say 'new $var';      # new $var
say 'arr @ary';      # arr @ary

say "new `$var`";      # new one

say "arr = `@ary`";           # arr = 3` `four` `5
$" = ';'; # $LIST_SEPARATOR, ' ' by default
say "arr = `@ary`";           # arr = 3`;`four`;`5

say "1st: `$ary[0]`";         # 1st: 3
say "two:(`@ary[1,2]`)";      # two(four;5)
say "hash el: `$hash{x}`";    # hash el: y
```

---

# Escape-последовательности

```perl
say 'test\n'; # test\n
say "test\n"; # test with newline char (0a)
```

```sh
\t          tab
\r          return
\n          newline
\e          escape
\x{263a}    unicode character with code in hex
\N{U+263A}  unicode character
\N{name}    unicode character by name
\033        octal code
```

## see: [perlop](http://perldoc.perl.org/perlop.html#Quote-and-Quote-like-Operators) for more

---

# Single quote

> Экранируемые символы только `\` и `'`. Остальные не экранируются

.left[
```perl
say '\"x';
say '\0x';
say '\x';
```
]
.right[
```sh
\"x
\0x
\x
```
]

.clear[]

--

.left[
```perl
say '\\x';
say '`\\`\x';
say '`\\\\`x';
say '`\\\\`\x';
say '`\\\\\\`x';
```
]
.right[
```sh
\x
\\x
\\x
\\\x
\\\x
```
]


---

# Особые esc-последовательности

```sh
\Q = quotemeta
\L = lc
\U = uc
\F = fc # foldcase
\E = end sequence
\l = lcfirst
\u = ucfirst
```

--

.left[
```perl
say "`\U`test string";
say "`\Utest\E` string";
say "`\ut`est string"; 

say "\Q.+*/\E";
say quotemeta('.+*/');
```
]
.right[
```sh
TEST STRING
TEST string
Test string

\.\+\*\/
\.\+\*\/
```
]

---

# Содержание

* Структуры данных
    - Массивы
    - Хэши
    - Ссылки
* Функции для работы со списками
* Управление циклами
* Постфиксная запись
* Интерполяция в строках
* **Функции**
    - Декларация
    - Аргументы
    - Использование

---

# Функции: объявление

.left[
```perl
sub NAME;
sub NAME BLOCK
$var = sub BLOCK;
```
]
.right[
```sh
forward declaration
declaration
anonymous declaration
```
]

```perl
sub my_function;
# ...
sub my_function {
    ...
}

my $anon = sub { ... };
```

.footer[[perlsub](http://perldoc.perl.org/perlsub.html)]

---

# Функции: аргументы

```perl
`@_` # специальный массив, содержащий все аргументы
```

```perl
sub my_fun {
    my $one_arg = shift; # shift @_
}
```

```perl
sub my_fun {
    my ($one_arg) = @_;
}
```

```perl
sub my_fun {
    my ($one,$two,$three) = @_;
}
```

---

# Функции: вызов

```perl
my_fun(); # no args
my_fun($arg); # one arg
my_fun($one,$two); # two args

my_fun(@array); # pass array as a list of args
my_fun(%hash); # pass hash as a list of args

my $res = my_fun(); # take single result
my @res = my_fun(); # take list result
my ($x,$y) = my_fun(); # take list into vars

$sub->();
$sub->($arg);
```

---

.left[
```perl
sub add {
    my ($x,$y) = @_;
    return $x + $y;
}
sub math {
    my ($x,$y) = @_;
    # last statement
    # is returned
    $x+$y, $x-$y;
}
sub div {
    # access directly
    $_[0] / $_[1];
}
sub inc {
    ++$_[0];
}
```
]
.right[
```perl
my $q = 3;
my $z = 7;
my @av = (1,4);

say add(1,2);   # 3
say add($q,$z); # 10
say add(@av);   # 5

say math(@av);  # 5 -3

say math @av;   # 5 -3
say add 1,2;    # 3

say div 4,8;    # 0.5

say inc $q;     # 4;
say inc $q;     # `5`;
say inc 0;      # die
```
]

---

# Список документации

* [perlsyn](http://perldoc.perl.org/perlsyn.html)
* [perldata](http://perldoc.perl.org/perldata.html)
* [perlref](http://perldoc.perl.org/perlref.html)
* [perlsub](http://perldoc.perl.org/perlsub.html)
* [perlfunc](http://perldoc.perl.org/perlfunc.html)
* [perlglossary](http://perldoc.perl.org/perlglossary.html)

---

# Домашнее задание

На вход функции подается список участников.
Каждый аргумент - либо имя холостого участника, либо ссылка на массив из имён супружеской пары. Имена уникальны.

Программа должна случайно выбрать пары дарящий → даритель для всех участников по следующим правилам:

Никто не дарит подарок сам себе.
Никто не дарит подарок своему супругу.
Два участника не дарят подарок друг другу.
Два участника не дарят подарок одному и тому же третьему.

Результатом функции должен быть список ссылок на массив из пар дарящий → даритель

## Подсказки

* При случайном подборе может получиться неразрешимое сочетание. В этом случае самый простой способ - повторить подбор
* Не забывайте использовать хэши. Они позволяют работать с множествами за O(1) вместо O(n)
* Проверяйте аргументы.

---
class:center, middle

# \_\_END\_\_

---
class:lastpage title

# Спасибо за внимание!

## Оставьте отзыв

.teacher[![teacher]()]
















