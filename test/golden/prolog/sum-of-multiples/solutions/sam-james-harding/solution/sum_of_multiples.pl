multiples_below(Limit, N, Multiples) :-
    Max is div(Limit, N),
    findall(
        X, 
        (between(1, Max, Multiplier), X is N * Multiplier, X < Limit), 
        Multiples
    ).

sum_of_multiples(Factors, Limit, Sum) :-
    maplist(multiples_below(Limit), Factors, MultiplesList),
    flatten(MultiplesList, Multiples),
    sort(Multiples, UniqueMultiples),
    sum_list(UniqueMultiples, Sum).