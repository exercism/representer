can_chain([]).
can_chain([(X, X)]).
can_chain([(X, Y)]) :- X \= Y, fail.
can_chain([(X, Y), (X, Y)]).
can_chain([(X, Y), (Y, X)]).
can_chain([(Y, X), (X, Y)]).
can_chain([(Y, X), (Y, X)]).


can_chain(Ls) :-
    length(Ls, Len),
    Len > 2,
    lowest_freq_num_pair(Ls, Freq+Num),
    format('lowest_freq_num_pair ~w~n', [Freq-Num]),
    Freq > 1,
    format('Freq ~w~n', [Freq]),
    remove_num(Ls, Num, ResultLs),
    format('lowest_freq_num_pair ~w, new ls ~w~n', [Freq-Num, ResultLs]),
    can_chain(ResultLs).

remove_num(Ls, Num, Result) :-
    nth0(I1, Ls, (Num, Num), Result),
    nth0(I2, Ls, (Num, X)),
	I1 =\= I2.

remove_num(Ls, Num, Result) :-
    nth0(I1, Ls, (Num, Num), Result),
    nth0(I2, Ls, (X, Num)),
	I1 =\= I2.

remove_num(Ls, Num, Result) :-
    format('remove_num ~w, ~w~n', [Ls, Num]),
    nth0(I1, Ls, (X, Num), LsWithout1),
    nth0(I2, LsWithout1, (Num, Y), WithoutBoth),
	I1 =\= I2,
    Result = [(X, Y) | WithoutBoth].

remove_num(Ls, Num, Result) :-
    nth0(I1, Ls, (Num, X), LsWithout1),
    nth0(I2, LsWithout1, (Num, Y), WithoutBoth),
	I1 =\= I2,
    Result = [(X, Y) | WithoutBoth].

remove_num(Ls, Num, Result) :-
    nth0(I1, Ls, (X, Num), LsWithout1),
    nth0(I2, LsWithout1, (Y, Num), WithoutBoth),
	I1 =\= I2,
    Result = [(X, Y) | WithoutBoth].

lowest_freq_num_pair(Ls, Freq) :-
    foldl([(X, Y), Acc, NewAcc]>>(NewAcc = [X, Y | Acc]), Ls, [], All),
    msort(All, Sorted),
    clumped(Sorted, Clumps),
    transpose_pairs(Clumps, [Freq | _]).
