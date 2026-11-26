% -----------------------------------------------------------------------------
% exercism.org
% Prolog Track Exercise: roman_numerals
% Contributed: Anthony J. Borla (ajborla@bigpond.com)
%
% Platform:   SWI-Prolog (https://www.swi-prolog.org/)
% Testing:    swipl -f roman_numerals.pl -s roman_numerals_tests.plt
%                   -g run_tests,halt -t 'halt(1)'
% -----------------------------------------------------------------------------

% -----------------------------------------------------------------------------
% convert(?N, ?Numeral)
% ----
% Bi-directional predicate that, for the following argument instantiations
%  converts Roman numeral to/from decimal values:
% - +N, -Numeral -> Numeral instantiated with Roman numeral string of value N
% - -N, +Numeral -> N instantiated with integer value of Numeral
% Fails if both variables are not instantiated.
% -----------------------------------------------------------------------------
convert(N, Numeral) :-
    var(N), var(Numeral), fail, !.

convert(N, Numeral) :-
    integer(N), N > 0, N < 4000,
    dec2roman(N, Numeral), !.

convert(N, Numeral) :-
    string(Numeral), string_length(Numeral, NumeralLength),
    NumeralLength > 0, NumeralLength < 16,
    string_chars(Numeral, NumeralChars),
    reverse(NumeralChars, NumeralCharsRev),
    forall(member(X, NumeralCharsRev),
           member(X, ['I', 'V', 'X', 'L', 'C', 'D', 'M'])),
    roman2dec(NumeralCharsRev, N), !.

% -----------------------------------------------------------------------------
% dec2roman(+N, -Roman)
% ----
% Unifies Roman to the Roman numeral eqivalent of the decimal value, N.
% -----------------------------------------------------------------------------
dec2roman(0, '') :- !.

dec2roman(N, Roman) :-
    dec_roman(Decimal, RomanAtom),
    N >= Decimal,
    NewN is N - Decimal,
    dec2roman(NewN, NewRoman), 
    string_concat(RomanAtom, NewRoman, Roman). 

% -----------------------------------------------------------------------------
% roman2dec(+Roman, -N)
% ----
% Unifies N to the equivalent decimal value of Roman.
% -----------------------------------------------------------------------------
roman2dec(Roman, N) :- roman2dec(Roman, 0, N).

roman2dec([], CumDecValue, CumDecValue) :- !.

roman2dec([Last], CumDecValue, N) :-
    roman_accumulate([Last], CumDecValue, NewDecValue),
    roman2dec([], NewDecValue, N), !.

roman2dec([L, R|Tail], CumDecValue, N) :-
    roman_accumulate([R, L], CumDecValue, NewDecValue),
    roman2dec(Tail, NewDecValue, N).

roman2dec([L, R|Tail], CumDecValue, N) :-
    roman_accumulate([L], CumDecValue, NewDecValue),
    roman2dec([R|Tail], NewDecValue, N).

% Helper
roman_accumulate(RomanValue, CumDecValue, NewDecValue) :-
    atomic_list_concat(RomanValue, RomanAtom),
    dec_roman(DecValue, RomanAtom),
    NewDecValue is DecValue + CumDecValue.

% -----------------------------------------------------------------------------
% dec_roman(+DecValue, +RomanValue)
% ----
% Set of facts used as lookup table for Decimal <=> Roman conversion.
% -----------------------------------------------------------------------------
dec_roman(1000, 'M').
dec_roman(900, 'CM').
dec_roman(500, 'D').
dec_roman(400, 'CD').
dec_roman(100, 'C').
dec_roman(90, 'XC').
dec_roman(50, 'L').
dec_roman(40, 'XL').
dec_roman(10, 'X').
dec_roman(9, 'IX').
dec_roman(5, 'V').
dec_roman(4, 'IV').
dec_roman(1, 'I').

% -----------------------------------------------------------------------------
% Module version in MAJOR.MINOR.PATCH format
% -----------------------------------------------------------------------------
version('1.3.0').
