Домашнее задание JSONL
======================

Треубется написать модуль, который экспортирует функции
`encode_jsonl` и `decode_jsonl`, которые кодируют и декодируют данные
в формате <a href="http://jsonlines.org/">JSON Lines</a>.

Для работы с JSON-ом можно (и нужно) использовать модуль [JSON](https://metacpan.org/pod/JSON).

Пример
------

```perl
use Local::JSONL qw(
    encode_jsonl
    decode_jsonl
);

$string = encode_jsonl([
    {a => 1},
    {b => 2},
]);

$array_ref = decode_jsonl(
    '{"a": 1}' + "\n" +
    '{"b": 2}'
);
```
