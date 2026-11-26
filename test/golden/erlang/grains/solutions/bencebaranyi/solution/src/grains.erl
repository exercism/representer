-module(grains).

-export([square/1, total/0]).

square(Square) when Square < 1; Square > 64 -> {error, "square must be between 1 and 64"};
square(1) -> 1;
square(Square) -> 
    trunc(square(Square - 1) * 2).

total() -> 
    lists:foldl(fun(X, Acc) ->
        Acc+square(X)
    end, 0, lists:seq(1,64)).
