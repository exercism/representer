-module(perfect_numbers).

-export([classify/1]).


classify(Number) when Number =< 0 -> error("");
classify(Number) ->
  Array = case Number rem 2 == 0 of
          true -> lists:seq(1, Number div 2);
          false -> lists:seq(1, (Number-1) div 2)
        end,

  Divs = lists:filter(fun(Y) -> Number rem Y /= 0 end, Array),
  Sum = lists:foldl(fun(X, Sum) -> X + Sum end, 0, Divs),

  case Sum of
    Number -> perfect;
    _ when Sum < Number -> deficient;
    _ -> abundant
  end.



