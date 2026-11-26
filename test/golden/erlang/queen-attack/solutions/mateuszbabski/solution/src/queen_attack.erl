-module(queen_attack).

-export([can_attack/2]).


can_attack({Wx, Wy} = WhiteQueen, {Bx, By} = BlackQueen) ->
    Ydist = By - Wy,
    Xdist = Bx - Wx,

    if 
        Ydist == 0 orelse Xdist == 0 -> true;
        abs(Ydist) == abs(Xdist) -> true;
        true -> false
    end.                 
        
