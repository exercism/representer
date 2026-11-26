

anagram(Word, Options, Matching):-
    include(is_permutation(Word), Options, Matching).

is_permutation(Word1, Word2) :-
    string_lower(Word1, LwrWord1),
    string_lower(Word2, LwrWord2),
    LwrWord1 \== LwrWord2,
    string_chars(LwrWord1, Chars1),
    string_chars(LwrWord2, Chars2),
    msort(Chars1, Sorted1),
    msort(Chars2, Sorted1).
