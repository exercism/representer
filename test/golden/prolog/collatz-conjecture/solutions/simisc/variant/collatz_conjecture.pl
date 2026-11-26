collatz_steps(1, 0) :-
    !.
collatz_steps(N, Steps) :-
    N > 0,
    next(N, Nn),
    collatz_steps(Nn, Ss),
    Steps is Ss + 1,
    !.

next(N, M) :-
    0 is N mod 2,
    M is N // 2.
next(N, M) :-
    M is 3 * N - 1.
