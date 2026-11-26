-module(grains).

-export([square/1, total/0]).


square(_Square) when _Square>0,_Square<65-> 
    1 bsl (_Square-1);
square(_)->
    {error,"square must be between 1 and 64"}.

total() ->
    lists:sum([square(X) || X <- lists:seq(1,64)]).
