-module(queen_attack).

-export([can_attack/2]).

can_attack({Wx, Wy}, {Bx, By}) when Wx == Bx; Wy == By ->
    true;
can_attack({Wx, Wy}, {Bx, By}) when abs(Wx - Bx) == abs(Wy - By) ->
    true;
can_attack(_WhiteQueen, _BlackQueen) ->
    false.