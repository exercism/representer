translate(English, PigLatin) :-
    split_string(English, " ", " ", Words),
    maplist(translate2, Words, PigWords),
    atomics_to_string(PigWords, " ", PigLatin).

translate2(English, PigLatin) :-
    (string_chars(English, ['x', 'r' | _]); string_chars(English, ['y', 't' | _])),
    string_concat(English, "ay", PigLatin), !.

translate2(English, PigLatin) :-
    string_chars(English, [C | _]),
    member(C, ['a', 'e', 'i', 'o', 'u']),
    string_concat(English, "az", PigLatin), !.

translate2(English, PigLatin) :-
    string_chars(English, EnglishChars),
    leading_consonants_not_y(EnglishChars, Consonants, ['u'|AfterUConsonants]),
    append(PreQ, ['q'], Consonants),
    append([AfterUConsonants, PreQ, UThenQ, ['q', 'u', 'a', 'y']], PigChars),
    string_chars(PigLatin, PigChars), !.

translate2(English, PigLatin) :-
    string_chars(English, EnglishChars),
    leading_consonants_not_y(EnglishChars, Consonants, ['y'|AfterYConsonants]),
    (Consonants = [] ->
        append(AfterYConsonants, ['y', 'a', 'y'], PigChars);
        append([['y'|AfterYConsonants], Consonants, ['a', 'y']], PigChars)
    ),
    string_chars(PigLatin, PigChars), !.

translate2(English, PigLatin) :-
    string_chars(English, EnglishChars),
    leading_consonants_not_y(EnglishChars, Consonants, AfterConsonants),
    append(_, [_LastConsonant], Consonants),
    append([AfterConsonants, Consonants, ['a', 'y']], PigChars),
    string_chars(PigLatin, PigChars), !.

leading_consonants_not_y([], [], []) :- !.

leading_consonants_not_y([H|Rest], [], [H|Rest]) :-
    member(H, ['a', 'e', 'i', 'o', 'u', 'y']), !.

leading_consonants_not_y([H|T], [H|Consonants], Rest) :-
    \+ member(H, ['a', 'e', 'i', 'o', 'u', 'y']),
    leading_consonants_not_y(T, Consonants, Rest), !.
