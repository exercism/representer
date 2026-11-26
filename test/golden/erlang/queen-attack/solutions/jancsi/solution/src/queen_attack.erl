-module(queen_attack).

-export([can_attack/2]).

can_attack({X,_WhiteY}, {X,_BlackY}) -> true;
can_attack({_WhiteX,Y}, {_BlackX,Y}) -> true;
can_attack({WhiteX,WhiteY}, {BlackX,BlackY}) -> 
    abs(WhiteX - BlackX) == abs(WhiteY - BlackY).