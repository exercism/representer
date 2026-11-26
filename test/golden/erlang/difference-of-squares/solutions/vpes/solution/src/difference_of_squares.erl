-module(difference_of_squares).
-export([difference_of_squares/1, square_of_sum/1, sum_of_squares/1]).

square_of_sum(_Number) -> trunc(math:pow(sum(_Number), 2)).

sum_of_squares(1) -> 1;
sum_of_squares(_Number) -> trunc(math:pow(_Number, 2)) + sum_of_squares(_Number-1).


difference_of_squares(_Number) -> square_of_sum(_Number) - sum_of_squares(_Number).

sum(1) -> 1;
sum(_Number) -> _Number + sum(_Number-1).