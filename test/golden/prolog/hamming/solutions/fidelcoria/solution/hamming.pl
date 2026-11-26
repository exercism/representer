% count the number of disagreements
hamming_distance(Str1, Str2, Dist) :-
    string_length(Str1, L),
    string_length(Str2, L),
    string_chars(Str1, Strand1),
    string_chars(Str2, Strand2),
    hamming_distance(Strand1, Strand2, 0, Dist).

hamming_distance([], [], Acc, Acc).
hamming_distance([Nuc1 | Str1], [Nuc2 | Str2], Acc, Dist) :-
    (   Nuc1 = Nuc2
    ->  hamming_distance(Str1, Str2, Acc, Dist)
    ;   NewAcc is Acc + 1,
        hamming_distance(Str1, Str2, NewAcc, Dist)
    ).