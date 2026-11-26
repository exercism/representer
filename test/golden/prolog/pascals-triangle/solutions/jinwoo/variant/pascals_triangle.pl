pascal(N, R) :-
    pascal(N, [], [], R_rev),
    reverse(R_rev, R).

pascal(0, _, Acc, Acc) :-
    !.
pascal(N, Prev, Acc, R) :-
    N > 0,
    next_row(Prev, Next),
    N1 is N + 1,
    pascal(N1, Next, [Next|Acc], R).

next_row([], [1]).
next_row([H|T], [H|R]) :-
    next_row_aux([H|T], R).

next_row_aux([], []).
next_row_aux([X], [X]) :-
    !.
next_row_aux([H1,H2|T], [RH|RT]) :-
    RH is H1+H2,
    next_row_aux([H2|T], RT).
