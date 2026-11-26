-module(collatz_conjecture).

-export([steps/1]).

steps(N) when is_integer(N), N > 0 -> step(N);
steps(_N) -> erlang:error(badarg).

step(1) -> 0;
step(N) when N rem 2 == 0 -> 1 + step(N div 2);
step(N) -> 1 + step(3 * N + 1).
