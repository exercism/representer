convert(N, "PlingPlangPlong") :-
    0 =:= N mod 3, 0 =:= N mod 5, 0 =:= N mod 7.

convert(N, "PlingPlang") :-
    0 =:= N mod 3, 0 =:= N mod 5.

convert(N, "PlingPlong") :-
    0 =:= N mod 3, 0 =:= N mod 7.

convert(N, "PlangPlong") :-
    0 =:= N mod 5, 0 =:= N mod 7.

convert(N, "Pling") :-
    0 =:= N mod 3.

convert(N, "Plang") :-
    0 =:= N mod 5.

convert(N, "Plong") :-
    0 =:= N mod 7.

convert(N, M) :-
    number_string(N, M).