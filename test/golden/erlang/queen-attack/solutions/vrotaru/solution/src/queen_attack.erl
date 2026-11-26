-module(queen_attack).

-export([can_attack/2]).

can_attack({X, _}, {X, _}) -> true;
can_attack({_, Y}, {_, Y}) -> true;
can_attack({XW, YW}, {XB, YB}) ->
  DX = XW - XB,
  DY = YW - YB,
  (DX =:= DY) or (DX + DY =:= 0);
can_attack(_, _) -> false.
