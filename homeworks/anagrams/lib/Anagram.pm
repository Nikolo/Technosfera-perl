package Anagram;

use 5.010;
use utf8;
use strict;
use warnings;
use feature 'unicode_strings';

=encoding UTF8

=head1 SYNOPSIS

Поиск анаграмм

=head1 anagram($arrayref)

Функцию поиска всех множеств анаграмм по словарю.

Входные данные для функции: ссылка на массив - каждый элемент которого - слово на русском языке в кодировке utf8

Выходные данные: Ссылка на хеш множеств анаграмм.

Ключ - первое встретившееся в словаре слово из множества
Значение - ссылка на массив, каждый элемент которого слово из множества, в том порядке в котором оно встретилось в словаре в первый раз.

Множества из одного элемента не должны попасть в результат.

Все слова должны быть приведены к нижнему регистру.
В результирующем множестве каждое слово должно встречаться только один раз.
Например

anagram(['пятак', 'ЛиСток', 'пятка', 'стул', 'ПяТаК', 'слиток', 'тяпка', 'столик', 'слиток'])

должен вернуть ссылку на хеш


{
    'пятак'  => ['пятак', 'пятка', 'тяпка'],
    'листок' => ['листок', 'слиток', 'столик'],
}

=cut

sub anagram {
    my $words_list = shift;
    my %dictionary;
    my $word_arr;
    
    for my $word(@$words_list)
    {
        $word = lc "$word";
        $word_arr = join "", sort(split //,$word);
        $dictionary{$word} =  $word_arr;
    }
    
    my %result;
    
    for my $word(keys %dictionary)
    {
        my @loc_arr;
        for my $item(keys %dictionary)
        {
            if($dictionary{$item} eq $dictionary{$word})
            {
                push @loc_arr, $item;
                delete $dictionary{$item};
            }
        }
        @result{$word} =  @loc_arr;
    }

    #
    # Поиск анограмм
    #

    return \%result;
}

1;
