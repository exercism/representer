hamming_distance(Str1, Str2, Dist) :-
    string_chars(Str1, Chars1),
    string_chars(Str2, Chars2),
    hamming_distance_chars(Chars1, Chars2, Dist).

hamming_distance_chars([], [], 0).
hamming_distance_chars([H|T1], [H|T2], Dist) :- hamming_distance_chars(T1, T2, Dist).
hamming_distance_chars([H1|T1], [H2|T2], Dist) :- hamming_distance_chars(T1, T2, Dist2), succ(Dist2, Dist).
