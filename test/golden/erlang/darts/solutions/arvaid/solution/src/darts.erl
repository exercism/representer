-module(darts).

-export([score/2]).

score(X, Y) ->
    R = radius(X, Y),
    if
        R > 10 -> 0;
        R > 5 -> 1;
        R > 1 -> 5;
        true -> 10
    end.

radius(X, Y) ->
    math:sqrt(X * X + Y * Y).
