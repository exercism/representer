-module(darts).

-export([score/2]).

score(_X, _Y) ->
    Dis = math:sqrt(_X*_X + _Y*_Y),
    if
        Dis =< 1 ->
            10;
        Dis =< 5 ->
            5;
        Dis =< 10 ->
            1;
        true ->
            0
    end.

