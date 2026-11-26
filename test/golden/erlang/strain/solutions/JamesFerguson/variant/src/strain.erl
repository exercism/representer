-module(strain).

-export([keep/3, discard/2]).

keep(_Fn, []) -> [];
keep(Fn, [H | T]) ->
  case Fn(H) of
    true -> [H] ++ keep(Fn, T);
    _ -> keep(Fn, T)
  end.

discard(Fn, List) ->
  keep(fun(X) -> not Fn(X) end, List).
