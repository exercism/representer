-module(run_length_encoding).

-export([decode/1, encode/1]).



decode(String) ->
  decode(String, []).

decode([], Decoded) ->
  lists:flatten(Decoded);
decode(String, Decoded) ->
  case string:to_integer(String) of
    {error, no_integer} ->
      [H | Tail] = String,
      decode(Tail, Decoded ++ [H]);
    {Counter, Rest} ->
      [H | Tail] = Rest,
      Part = string:pad("", Counter, leading, [H]),
      decode(Tail, Decoded ++ Part)
  end.

encode(String) ->
  encode(String, 1, []).

encode([], _Counter, Encoded) ->
  string:join(Encoded, "");
encode([H, H | _Tail] = String, Counter, Encoded) ->
  encode(tl(String), Counter + 1, Encoded);
encode([H | Tail], 1, Encoded) ->
  encode(Tail, 1, Encoded ++ [[H]]);
encode([H | Tail], Counter, Encoded) ->
  encode(Tail, 1, Encoded ++ [integer_to_list(Counter) , [H]]).