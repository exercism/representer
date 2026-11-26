leap(N) :-
    divides(N, 400), !;
    divides(N, 4), \+ divides(N, 100).

divides(N, M) :-
    mod(N, M) =:= 0.
