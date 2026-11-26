:- set_prolog_flag(double_quotes, chars).

paired(String) :-
    string_chars(String, Chars),
    scan(Chars, []).

scan([], []).
scan([C|Cs], Openings) :-
    open_close(C, _), !,
    scan(Cs, [C|Openings]).
scan([C|Cs], [O|Openings]) :-
    open_close(O, C), !,
    scan(Cs, Openings).
scan([C|Cs], Openings) :-
    \+ open_close(_, C),
    scan(Cs, Openings).

open_close('[', ']').
open_close('{', '}').
open_close('(', ')').
