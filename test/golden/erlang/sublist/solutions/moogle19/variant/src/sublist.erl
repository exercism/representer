-module(sublist).

-export([is_equal/2, is_sublist/2, is_superlist/2, is_unequal/2, relation/2]).

is_equal(L, L) ->
  true;
is_equal(_L1, _L2) ->
  false.

is_sublist([], _L) -> 
	true;
is_sublist(L1, [H|T]) ->
  starts_with([H|T], L1) and is_sublist(L1, T);
is_sublist(_L, []) -> 
	false.


is_superlist(L1, L2) ->
  is_sublist(L2, L1).

is_unequal(L, L) ->
  false;
is_unequal(_L1, _L2) ->
  true.

relation(L1, L2) -> 
  case {is_equal(L1, L2), is_sublist(L1, L2), is_superlist(L1, L2)} of
    {true, _, _} -> equal;
    {_, true, _} -> sublist;
    {_, _, true} -> superlist;
    _ -> unequal
  end.
		

starts_with(_L1, []) ->
	true;
starts_with([H|T1], [H|T2]) ->
	starts_with(T1, T2);
starts_with(_L1, _L2) -> false.