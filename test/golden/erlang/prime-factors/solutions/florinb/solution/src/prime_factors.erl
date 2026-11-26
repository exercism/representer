-module(prime_factors).

-export([factors/1]).


factors(Value) ->
  factors(Value, 2, []).

factors(1, _Prime, Res) -> Res;
factors(Value, Prime, Res) when Value rem Prime == 0 ->
  factors(Value div Prime, 2, [Prime|Res]);
factors(Value, Prime, Res) ->
 factors(Value, Prime+1, Res).
