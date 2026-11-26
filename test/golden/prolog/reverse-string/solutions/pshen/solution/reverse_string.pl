string_reverse(S, Reversed) :-
    string_chars(S, Chars),
    reverse(Chars, RevChars),
    string_chars(Reversed, RevChars).
