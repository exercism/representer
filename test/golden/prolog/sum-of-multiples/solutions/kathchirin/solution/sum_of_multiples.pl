sum_of_multiples(Factors, Limit, Sum) :-
    Limit1 is Limit - 1,
    findall(X, (between(1, Limit1, X), divisible_by_any(X, Factors)), Multiples),
    sort(Multiples, UniqueMultiples),
    sum_list(UniqueMultiples, Sum).

divisible_by_any(X, [F|_]) :-
    F \= 0,
    X mod F =:= 0.
divisible_by_any(X, [_|Fs]) :-
    divisible_by_any(X, Fs).