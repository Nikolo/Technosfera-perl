Интерполяция
============

##### Для строк, где не требуется интерполяция, лучше использовать одинарные кавычки.

Хорошо:
```perl
my $fullname = 'Judy Hopps';
```

Плохо:
```perl
my $fullname = "Judy Hopps"; # but why?
```

##### Для интерполяции функций и сложных конструкций лучше использовать `sprintf` (а не `@{[]}`).

Хорошо:
```perl
my $fullname = spritnf('%s %s', get_name(), SurnameRetriever->new()->retrieve());
```

Тоже неплохо:
```perl
my $name = get_name();
my $surname = SurnameRetriever->new()->retrieve();
my $fullname = "$name $surname";
```

Плохо:
```perl
my $fullname = "@{[get_name()]} @{[SurnameRetriever->new()->retrieve()]}"; # is it even valid?
```

##### Никогда не смешивайте инетрполяцию и `sprintf`, т. к. интерполяция может изменить шаблон и сломать подстановку параметров.

Хорошо:
```perl
my $name = '%s'; # no problem
my $fullname = sprintf("%s %s", $name, get_surname());
```

Плохо (вообще работает не так, как кажется):
```perl
my $name = '%s'; # oops
my $fullname = sprintf("$name %s", get_surname()); # :(
```

##### Избегайте использования конкатенации вместо интерполяции, она плохо воспринимается.

Плохо:
```perl
print 'My name is ' . $name . ' and surname is '. $surname . ' !';
```

##### Избегайте экранирования в строках, в качестве кавычки можно использовать любой другой символ (отдавайте предпочтение `{}`).

Хорошо:
```perl
print q{Bart says "I didn't do it!"};
print qq{$simpson says "I didn't do it!"};
```

Плохо:
```perl
print 'Bart says "I didn\'t do it!"';
print "$simpson says \"I didn't do it!\"";
```

##### Часто примитивный шаблон можно заменить на `join`.

Хорошо:
```perl
my $fullname = join("\t", $title, $name, $surname, $father_name, $extra_name);
```

Плохо :
```perl
my $fullname = "$title\t$name\t$surname\t$father_name\t$extra_name";
```
