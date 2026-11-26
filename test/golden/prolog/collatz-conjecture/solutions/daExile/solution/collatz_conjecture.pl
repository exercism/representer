collatz_steps(1, 0).
collatz_steps(N, Steps):-
    N > 1, N mod 2 =:= 0, Nnext is N div 2, collatz_steps(Nnext, Snext), Steps is Snext + 1.
collatz_steps(N, Steps):-
    N > 1, N mod 2 =:= 1, Nnext is 3 * N + 1, collatz_steps(Nnext, Snext), Steps is Snext + 1.