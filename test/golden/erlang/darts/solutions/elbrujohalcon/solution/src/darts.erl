-module(darts).

-export([score/2]).

score(X, Y) ->
    case distance(X,Y) of
        D when D > 10 -> 0;
        D when D > 5, D =< 10 -> 1;
        D when D > 1, D =< 5 -> 5;
        D when D >= 0, D =< 1 -> 10
    end.

distance(X, Y) -> math:sqrt(X*X + Y*Y).