Написать [функцию свертки списка](https://ru.wikipedia.org/wiki/%D0%A1%D0%B2%D1%91%D1%80%D1%82%D0%BA%D0%B0_%D1%81%D0%BF%D0%B8%D1%81%D0%BA%D0%B0) `reduce` по аналогии с `map` и `grep`.

Заготовка
---------

```perl
sub reduce(&@) {
  my ($f, @list) = @_;
  
  return;
}

# returns 10
reduce {
  my ($sum, $i) = @_;
  $sum + $i;
} 1, 2, 3, 4;
```
