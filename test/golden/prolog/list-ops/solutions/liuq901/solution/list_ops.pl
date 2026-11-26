custom_length([], 0).
custom_length([_|T], Length) :-
    custom_length(T, Tmp), succ(Tmp, Length).

custom_append([], List, List).
custom_append([H|T], List, [H|Rest]) :-
    custom_append(T, List, Rest).

custom_concat([], []).
custom_concat([H|T], Concatenated) :-
    custom_concat(T, Tmp), custom_append(H, Tmp, Concatenated).

custom_reverse([], []).
custom_reverse([H|T], Reversed) :-
    custom_reverse(T, Tmp), custom_append(Tmp, [H], Reversed).

custom_map(_, [], []) :- !.
custom_map(Goal, [H1|T1], [H2|T2]) :-
    call(Goal, H1, H2), custom_map(Goal, T1, T2).

custom_filter(_, [], []) :- !.
custom_filter(Goal, [H|T], Filtered) :-
    custom_filter(Goal, T, Tmp),
    (
        call(Goal, H), Filtered = [H|Tmp], !;
        Filtered = Tmp
    ).

custom_foldl(_, State, [], State) :- !.
custom_foldl(Goal, State, [H|T], Folded) :-
    call(Goal, State, H, Tmp), custom_foldl(Goal, Tmp, T, Folded).

custom_foldr(_, [], State, State) :- !.
custom_foldr(Goal, [H|T], State, Folded) :-
    custom_foldr(Goal, T, State, Tmp), call(Goal, H, Tmp, Folded).
