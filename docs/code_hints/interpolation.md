Строки
======

Для строк, где не требуется интерполяция, лучше использовать одинарные кавычки:

```perl
my $fullname = 'Judy Hopps';
```

Для интерполяции функций и сложных конструкций лучше использовать `sprintf` (а не `@{[]}`):

```perl
my $fullname = spritnf('%s %s', get_name(), SurnameRetriever->new()->retrieve());
```

Никогда не смешивайте инетрполяцию и `sprintf`, т. к. интерполяция может изменить шаблон и сломать подстановку параметров:

```perl
my $name = '%s'; # oops
my $fullname = sprintf("$name %s", get_surname()); # :(
```

Избегайте использования конкатенации вместо интерполяции, она плохо воспринимается:

```perl
print 'My name is ' . $name . ' and surname is '. $surname . ' !';
```
Часто примитивный шаблон можно заменить на `join`:

```perl
my $fullname = join(' ', $name, $surname);
```
