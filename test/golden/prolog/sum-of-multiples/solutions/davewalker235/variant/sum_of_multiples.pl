sum_of_multiples(_, 1, 0).
sum_of_multiples(Factors, Limit, Sum) :-
    Limit1 is Limit - 1,
    numlist(1, Limit1, List),
    include(filter(Factors), List, List1),
    sum_list(List1, Sum).

filter([H|T], I) :-
    0 =\= I mod H;
    filter(T, I).