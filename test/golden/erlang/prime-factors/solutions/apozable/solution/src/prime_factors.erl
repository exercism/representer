-module(prime_factors).

-export([factors/1]).

-spec factors(integer()) -> [integer()].
factors(Value) -> 
    search_factors(Value, 2, Value rem 2, []).

search_factors(1, _, _, List) -> List;
search_factors(Value, Divisor, 0, List) ->
    NewValue = trunc(Value/Divisor),
    NewRemainder = NewValue rem Divisor,
    search_factors(NewValue, Divisor, NewRemainder, lists:merge(List, [Divisor]));
search_factors(Value, Divisor, _Remainder, List) ->
    NewDivisor = Divisor + 1,  
    NewRemainder = Value rem NewDivisor,
    search_factors(Value, NewDivisor, NewRemainder, List).


