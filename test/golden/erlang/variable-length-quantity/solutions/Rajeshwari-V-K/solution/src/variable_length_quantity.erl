-module(variable_length_quantity).
-export([encode/1, decode/1]).
encode([]) -> [];
encode(Integers) ->
	lists:flatmap(fun encode_integer/1, Integers).
encode_integer(0) -> [0];
encode_integer(N) -> encode_integer(N, []).
encode_integer(0, Acc) -> Acc;
encode_integer(I, []) ->
  encode_integer(I div 128, [I rem 128]);
encode_integer(I, Acc) ->
  encode_integer(I div 128, [128 + I rem 128|Acc]).
  
decode([]) -> [];
decode(Integers) ->
  case lists:last(Integers) < 128 of
    true  -> decode(Integers, 0, []);
    false -> undefined
  end.
decode([], 0, Acc) -> 
  lists:reverse(Acc);
decode([H|T], N, Acc) when H < 128 ->
  decode(T, 0, [N * 128 + H|Acc]);
decode([H|T], N, Acc) ->
  decode(T, N * 128 + H - 128, Acc).