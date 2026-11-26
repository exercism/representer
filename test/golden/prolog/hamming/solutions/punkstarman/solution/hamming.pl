chars_hamming_distance([], [], 0).
chars_hamming_distance([C1 | Cs1], [C2 | Cs2], N) :-
    C1 = C2,
    chars_hamming_distance(Cs1, Cs2, N).
chars_hamming_distance([C1 | Cs1], [C2 | Cs2], N) :-
    C1 \= C2,
    chars_hamming_distance(Cs1, Cs2, M),
    N is M + 1.

hamming_distance(Str1, Str2, Dist) :-
    string_chars(Str1, Cs1),
    string_chars(Str2, Cs2),
    chars_hamming_distance(Cs1, Cs2, Dist).
