string_reverse("", "").
string_reverse(S, Reversed) :-
    string_chars(S, Chs),
    reverse(Chs, RChs),
    string_chars(Reversed, RChs).
