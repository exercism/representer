
sum_aux(0, M, M).
sum_aux(N, M, R) :-
    N > 0,
    X is N - 1,
    Y is M + N,
    sum_aux(X, Y, R).

sum_of(N, R) :-
    N >= 0,
    sum_aux(N, 0, R).

square_of_sum(N, Result) :-
    sum_of(N, R),
    Result is R**2.

sum_sq_aux(0, R, R).
sum_sq_aux(N, Acc, R) :-
    N >= 0,
    Acc1 is Acc + N*N,
    N1 is N - 1,
    sum_sq_aux(N1, Acc1, R).

sum_of_squares(N, Result) :-
    N >= 0,
    sum_sq_aux(N, 0, Result).


difference(N, Result) :-
    square_of_sum(N, X),
    sum_of_squares(N, Y),
    Result is X - Y.

