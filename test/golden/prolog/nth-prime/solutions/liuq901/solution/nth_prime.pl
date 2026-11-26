nth_prime(N, Prime) :-
    N > 0, prime(2, N, [], Primes),
    append(_, [Prime], Primes).

prime(Now, N, Acc, Result) :-
    length(Acc, N), Result = Acc, !;
    Next is Now + 1,
    (
        is_prime(Acc, Now), append(Acc, [Now], Tmp), !;
        Tmp = Acc
    ),
    prime(Next, N, Tmp, Result).

is_prime([], _) :- !.
is_prime([X|T], Now) :-
    Now mod X =\= 0,
    is_prime(T, Now).
