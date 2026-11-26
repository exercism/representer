convert(0, "") :- !.
convert(N, Numeral) :-
    subtract_the_most(N, Rest, SubtractedNumeral),
    convert(Rest, RestNumeral),
    string_concat(SubtractedNumeral, RestNumeral, Numeral).

subtract_the_most(N, Rest, "M") :-
    N >= 1000,
    Rest is N-1000,
    !.

subtract_the_most(N, Rest, "CM") :-
    N >= 900,
    Rest is N-900,
    !.

subtract_the_most(N, Rest, "D") :-
    N >= 500,
    Rest is N-500,
    !.

subtract_the_most(N, Rest, "CD") :-
    N >= 400,
    Rest is N-400,
    !.

subtract_the_most(N, Rest, "C") :-
    N >= 100,
    Rest is N-100,
    !.

subtract_the_most(N, Rest, "XC") :-
    N >= 90,
    Rest is N-90,
    !.

subtract_the_most(N, Rest, "L") :-
    N >= 50,
    Rest is N-50,
    !.

subtract_the_most(N, Rest, "XL") :-
    N >= 40,
    Rest is N-40,
    !.

subtract_the_most(N, Rest, "X") :-
    N >= 10,
    Rest is N-10,
    !.

subtract_the_most(N, Rest, "IX") :-
    N >= 9,
    Rest is N-9,
    !.

subtract_the_most(N, Rest, "V") :-
    N > 5,
    Rest is N-5,
    !.

subtract_the_most(N, Rest, "IV") :-
    N >= 4,
    Rest is N-4,
    !.

subtract_the_most(N, Rest, "I") :-
    N >= 1,
    Rest is N-1,
    !.

