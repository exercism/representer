keep(_, [], []).
keep(Goal, [H|T], [H|R]) :-
    call(Goal, H),
    keep(Goal, T, R).
keep(Goal, [H|T], R) :-
    \+ call(Goal, H),
    keep(Goal, T, R).

discard(_, [], []).
discard(Goal, [H|T], [H|R]) :-
    \+ call(Goal, H),
    discard(Goal, T, R).
discard(Goal, [H|T], R) :-
    call(Goal, H),
    discard(Goal, T, R).