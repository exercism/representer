:- use_module(library(apply)).

binary(String, Dec) :-
    string_chars(String, Chars),
    maplist(to_bit, Chars, Bits),
    foldl(shift_add, Bits, 0, Result),
    Dec is Result.

to_bit('1', 1).
to_bit('0', 0).

shift_add(X, Acc, Result) :- Result = 2*Acc + X.