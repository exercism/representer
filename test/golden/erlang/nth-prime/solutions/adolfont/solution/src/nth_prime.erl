-module(nth_prime).

-export([prime/1]).

prime(Number) when Number > 0 -> find_prime(2, Number);
prime(0) ->
    erlang:error("there is no zeroth prime", []).

find_prime(Integer, 0) -> Integer - 1;
find_prime(Integer, N) ->
    case is_prime(Integer) of
        true -> find_prime(Integer + 1, N - 1);
        false -> find_prime(Integer + 1, N)
    end.

is_prime(X) when X > 1 ->
    PotentialDividers = [Z
                          || Z <- lists:seq(2, trunc(math:sqrt(X)))],
    not
        lists:any(fun (PossibleDivider) ->
                          X rem PossibleDivider =:= 0
                  end,
                  PotentialDividers);
is_prime(_) -> false.
