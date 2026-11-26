-module(darts).

-export([score/2]).

score(X, Y) ->
    Distance = math:sqrt(X * X + Y * Y),
    if
        Distance > 10 ->
            0;
        Distance > 5 ->
            1;
        Distance > 1 ->
            5;
        true ->
            10
    end.
