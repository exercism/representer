score(Word, Score) :-
    string_lower(Word, String),
    string_chars(String, Chars),
    scrabble(Chars, Score).

scrabble([], 0).
scrabble([H | T], Score) :-
    scrabble(T, R),
    (
    member(H, ['q', 'z']) -> Score is R + 10;
    member(H, ['j', 'x']) -> Score is R + 8;
    member(H, ['k']) -> Score is R + 5;
    member(H, ['f', 'h', 'v', 'w', 'y']) -> Score is R + 4;
    member(H, ['b', 'c', 'm', 'p']) -> Score is R + 3;
    member(H, ['d', 'g']) -> Score is R + 2;
    member(H, ['a', 'e', 'i', 'o', 'u', 'l', 'n', 'r', 's', 't']) -> Score is R + 1
    ).

