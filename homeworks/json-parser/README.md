# Парсер JSON

Реализовать с помощью регулярных выражений парсер (синтаксический анализатор) формата данных JSON ([http://json.org](http://json.org)). На выходе необходимо получить структуру, аналогичную возвращаемой модулем JSON::XS.

Описать всё в модуле Local::JSONParser в виде экспортируемой функции parse_json:

```perl
use Local::JSONParser;
use DDP;

my $data = '{ "key" : "value", "array": [1,2,3]}';
my $struct = parse_json($data);
p $struct;
```

## Пример файла в виде JSON

data.json:
```json
{
  "key1": "string value",
  "key2": -3.1415,
  "key3": ["nested array"],
  "key4": { "nested": "object" },
}
```

## Тест с такими данными

```sh
> perl ex/test.pl data.json

\ {
    key1   "string value",
    key2   -3.1415,
    key3   [
        [0] "nested array"
    ],
    key4   {
        nested   "object"
    }
}

>
```

## Минимальный удовлетворительный набор:

1. Поддержать объект, массив, строку, число
```json
{ "k": "v" }, [1,2,3], "string", 123
```
2. В строке поддержать последовательности \", \n, \uXXXX
```json
"my string with \"\u410\n"
```
3. В числе поддержать унарный минус и десятичную точку
```json
0, 0.1234, -17000
```
4. Разрешается пропускать "висящую" запятую
```json
[ 1, 2, 3, ]
```
