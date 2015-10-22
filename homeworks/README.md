Как принимаются домашние задания
================================

Сдать домашнее задание можно очно в назначенное время или, что более предпочтительно, онлайн любому преподавателю.
Не забывайте, при очной сдаче у преподавателя обычно есть всего 5 минут на студента,
и у вас не будет времени исправить свои ошибки: все они немедленно приведут к снижению оценки.

Общие правила
-------------

* Попытка сдачи программы, которая не исполняется с `use strict` автоматически,
а также программы, которая выдает варнинги с включеным `use warnings`,
приводит к получению 0 баллов и существенному снижению оценки при пересдаче.
Проще говоря, не пытайтесь сдать задания, которые не работают с `use strict` и `use warnings`.
(Разумеется, эти правила не касаются однострочников.)

* Если у домашнего задания есть тесты (они лежат в этом репозитории), то их прохождение обязательно.

* Одно домашнее задание можно сдавать только одному преподавателю.

* Если первая попытка приходится на дату позже чем дата сдачи указанная в расписании — это приводит к снижению оценки.

Как проверить
-------------

Большинство заданий выложены в виде исходников перловых модулей (недописанных),
которые можно проверить стандартной мантрой:

```perl
perl Makefile.PL
make test
```

Результат выглядит примерно так:

```bash
cp lib/Local/Iterator/Function.pm blib/lib/Local/Iterator/Function.pm		
cp lib/Local/Iterator/File.pm blib/lib/Local/Iterator/File.pm		
cp lib/Local/Iterator/Aggregator.pm blib/lib/Local/Iterator/Aggregator.pm		
cp lib/Local/Iterator.pm blib/lib/Local/Iterator.pm		
cp lib/Local/Iterator/Array.pm blib/lib/Local/Iterator/Array.pm		
cp lib/Local/Iterator/Concater.pm blib/lib/Local/Iterator/Concater.pm		
PERL_DL_NONLAZY=1 /usr/bin/perl "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; est_harness(0, 'blib/lib', 'blib/arch')" t/*.t		
t/aggregator.t .. ok		
t/array.t ....... ok		
t/concater.t .... ok		
t/file.t ........ ok		
All tests successful.		
Files=4, Tests=25,  1 wallclock secs ( 0.02 usr  0.00 sys +  0.59 cusr  0.03 csys =  0.64 CPU)		
Result: PASS		
```
