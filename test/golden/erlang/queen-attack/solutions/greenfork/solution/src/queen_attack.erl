-module(queen_attack).

-export([can_attack/2]).


can_attack({WX, WY} = _WhiteQueen, {BX, BY} = _BlackQueen) ->
    if
        WX =:= BX -> true;
        WY =:= BY -> true;
        true -> abs(WX - BX) =:= abs(WY - BY)
    end.
