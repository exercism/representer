-module(darts).

-export([score/2]).


score(_X, _Y) ->
  Distance = math:sqrt(math:pow(_X, 2) + math:pow(_Y, 2)),
  if Distance > 10 -> 0; Distance > 5 -> 1; Distance > 1 -> 5; true -> 10 end.

