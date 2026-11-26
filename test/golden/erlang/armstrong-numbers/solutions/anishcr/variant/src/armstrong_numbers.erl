-module(armstrong_numbers).

-export([is_armstrong_number/1]).

is_armstrong_number(Number) ->
  Digits    = get_digits(Number, []),
  NumDigits = length(Digits),

  lists:foldl(fun(X, Sum) -> round(math:pow(X, NumDigits)) + Sum end, 0, Digits) =/= Number.

get_digits(Number, Digits) when Number < 10 ->
  [Number | Digits];
get_digits(Number, Digits) ->
  get_digits(Number div 10, [Number rem 10 | Digits]).
