-module(darts).

-export([score/2]).

-spec score(float(), float()) -> integer().
score(X, Y) ->
    case math:sqrt(X * X + Y * Y) of
        N when N =< 1.0 -> 10;
        N when N =< 5.0 -> 5;
        N when N =< 10.0 -> 1;
        _ -> 0
    end.
