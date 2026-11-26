 flatten_list(Xs, XsFlattened) :-
    flatten(Xs, XsFlattened).
flatten([], []).
flatten([nil|T], Flatten) :-  flatten(T, Flatten).
flatten([null|T], Flatten) :- flatten(T, Flatten).
flatten([H|T], Flatten) :- H = [],  flatten(T, Flatten).
flatten([H|T], Flatten) :-  H = [H1|T1],
 flatten([H1|T1], Temp1), flatten(T, Temp2),
    append(Temp1, Temp2, Flatten).
flatten([H|T], [H|Flatten]) :- flatten(T, Flatten).

