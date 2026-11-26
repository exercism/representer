-module(collatz_conjecture).

-export([steps/1]).


steps(_N, _Count) -> case _N of
        _N when _N<1 -> error(badarg);
        1 -> _Count;
        _ -> steps(step(_N), _Count + 1)
    end.

steps(_N) -> steps(_N, 0).

step(_N) -> case _N rem 2 of
        0 -> _N div 2;
        1 -> 3 * _N - 1
    end.