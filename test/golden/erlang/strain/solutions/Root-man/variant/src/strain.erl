-module(strain).
-export([test_version/1, keep/2, discard/2]).

test_version() -> 1.

-spec keep(function(), list()) -> list().
keep(Pred, List) ->
  walk(Pred, List, true, []).

-spec discard(function(), list()) -> list().
discard(Pred, List) ->
  walk(Pred, List, false, []).

-spec walk(function(), list(), boolean(), list()) -> list().
walk(Pred, [Head|Tail], Keep, Acc) ->
  case Pred(Head) of
    true ->
      if Keep ->
        walk(Pred, Tail, Keep, [Head] ++ Acc);
      true ->
        walk(Pred, Tail, Keep, Acc)
      end;
    _ ->
      if Keep ->
        walk(Pred, Tail, Keep, Acc);
      true ->
        walk(Pred, Tail, Keep, [Head] ++ Acc)
      end
  end;

walk(_Pred, [], _Keep, Acc) ->
  lists:reverse(Acc).