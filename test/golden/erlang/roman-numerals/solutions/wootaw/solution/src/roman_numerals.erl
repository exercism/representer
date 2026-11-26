-module(roman_numerals).

-export([roman/1]).


roman(Number) ->
    roman(Number, "__MDCLXVI", 1000).

roman(0, _) -> [];
roman(N, {S, _, _}) when N < 4 -> [S || _ <- lists:seq(1, N)];
roman(N, {S, M, _}) when N =:= 4 -> [S, M];
roman(N, {S, _, L}) when N =:= 9 -> [S, L];
roman(N, Letters = {_, M, _}) -> [M | roman(N - 5, Letters)].

roman(Number, [L, M, S], _) when Number < 10 ->
    roman(Number, {S, M, L});
roman(Number, [L, M | Letters = [S | _]], Base) ->
    roman(Number div Base, {S, M, L}) ++ roman(Number rem Base, Letters, Base div 10).
