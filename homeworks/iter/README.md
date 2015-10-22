Домашнее задание Iter
=====================

Требуется написать классы итераторов, которые отзываются на методы `next()` и `all()`.

`next()` возвращаетт пару `($val, 0)`, если очередное значение доступно и `(undef, 1)`, если значения кончились.

`all()` возвращает ссылку на массив всех оставшихся элементов.

Типы итераторов
---------------

Нужно реализовать 4 типа таких итераторов. Подробно их интерфейс можно изучить по коду.

### Array

Итерируется по массиву.

### File

Итерируется по строкам файла (без переносов строк). Может быть инстанцирован как именем файла, так и _манипулятором_ (filehandle).

### Aggregator

Итерируется по элементам другого итератора, возвращая каждый раз порции из N элементов (или меньше, вплоть до одного, если значений не хватает).

### Concater

Итерируется последовательно по элементам других итераторов.

Как проверить
-------------

```bash
$ perl Makefile.PL
Generating a Unix-style Makefile
Writing Makefile for Local::Iterator
Writing MYMETA.yml and MYMETA.json
$ make test
cp lib/Local/Iterator/Function.pm blib/lib/Local/Iterator/Function.pm
cp lib/Local/Iterator/File.pm blib/lib/Local/Iterator/File.pm
cp lib/Local/Iterator/Aggregator.pm blib/lib/Local/Iterator/Aggregator.pm
cp lib/Local/Iterator.pm blib/lib/Local/Iterator.pm
cp lib/Local/Iterator/Array.pm blib/lib/Local/Iterator/Array.pm
cp lib/Local/Iterator/Concater.pm blib/lib/Local/Iterator/Concater.pm
PERL_DL_NONLAZY=1 /usr/bin/perl "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness(0, 'blib/lib', 'blib/arch')" t/*.t
t/aggregator.t .. ok
t/array.t ....... ok
t/concater.t .... ok
t/file.t ........ ok
All tests successful.
Files=4, Tests=25,  1 wallclock secs ( 0.02 usr  0.00 sys +  0.59 cusr  0.03 csys =  0.64 CPU)
Result: PASS
```
