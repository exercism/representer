bin(['0'], 0).
bin(['1'], 1).
bin(['0'|T], Result) :- bin(T, Result).
bin(['1'|T], Result) :- bin(T, X), length(T, Y), Result is 2 ^ Y + X.

binary(Str, Dec) :- string_chars(Str, Chars), bin(Chars, Dec).