-module(queen_attack).

-export([can_attack/2]).

can_attack({R, _}, {R, _}) -> true;
can_attack({_, C}, {_, C}) -> true;
can_attack({R1, C1}, {R2, C2}) -> abs(R1 - R2) == abs(C1 - C2).
