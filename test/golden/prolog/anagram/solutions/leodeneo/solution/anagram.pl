check_anagram(A, B) :-
    string_lower(A, ALower),
    string_lower(B, BLower),
    ALower \= BLower,
    string_chars(ALower, AChars),
    string_chars(BLower, BChars),
    msort(AChars, ASorted),
    msort(BChars, BSorted),
    ASorted = BSorted.

anagram(Word, Candidates, Anagrams) :- include(call(check_anagram(Word)), Candidates, Anagrams).