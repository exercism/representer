-module(square_root).

-export([square_root/1]).


square_root(Radicand) -> square_root(Radicand, 1, 1).
square_root(Radicand, Xn, Iter) when Iter < 20 ->
    Next = Xn - ((Xn * Xn - Radicand) / (2 * Xn)),
    square_root(Radicand, Next, Iter + 1);
square_root(_, Xn, _) -> trunc(math:floor(Xn)).
