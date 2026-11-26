hamming_distance(Str1, Str2, Dist) :-
    string_chars(Str1, C1),
    string_chars(Str2, C2),
    hamming_distance_(C1, C2, Dist).

hamming_distance_(Str1, Str2, Dist) :-
    pairs_keys_values(Pairs, Str1, Str2),
    findall(A-B, (member(A-B, Pairs), A \= B), Diffs),
    length(Diffs, Dist).
