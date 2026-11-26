-module(queen_attack).
-export([can_attack/2]).

can_attack({X1, Y1}, {X2, Y2}) ->
    X1 =:= X2 orelse Y1 =:= Y2 andalso abs(X2 - X1) =:= abs(Y2 - Y1).