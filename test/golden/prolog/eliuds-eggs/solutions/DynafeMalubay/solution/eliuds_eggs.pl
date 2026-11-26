% eliuds_eggs.pl
% Count the number of eggs from encoded binary representation

egg_count(EncodedCount, Count) :-
    egg_count_helper(EncodedCount, 0, Count).

% Base case: when number is 0, return accumulated count
egg_count_helper(0, Acc, Acc) :- !.

% Recursive step: check lowest bit (N mod 2), then shift right (N // 2)
egg_count_helper(N, Acc, Count) :-
    Bit is N mod 2,
    NextN is N // 2,
    NewAcc is Acc + Bit,
    egg_count_helper(NextN, NewAcc, Count).

