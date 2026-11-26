-module(queen_attack).

-export([can_attack/2]).
-export_type([position/0, coordinate/0]).

-type position() :: 0..7.
-type coordinate() :: {position(), position()}.

-spec can_attack(coordinate(), coordinate()) -> boolean().
can_attack({X, _}, {X, _}) -> true;
can_attack({_, Y}, {_, Y}) -> true;
can_attack({X1, Y1}, {X2, Y2})
  when abs(X1 - X2) == abs(Y1 - Y2) -> true;
can_attack(_, _) -> false.
