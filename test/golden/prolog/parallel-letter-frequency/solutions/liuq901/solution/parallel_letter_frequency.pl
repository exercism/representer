frequencies(Texts, Frequencies) :-
    concurrent_maplist(count, Texts, Counts),
    foldl(merge_count, Counts, [], Frequencies).

count(Text, Count) :-
    string_lower(Text, Lower), string_chars(Lower, Chars),
    include(is_alpha, Chars, Filtered),
    concurrent_maplist(single, Filtered, SingleCounts),
    foldl(merge_single, SingleCounts, [], Count).

single(Char, Char-1) :- !.

merge_count(Count1, Count2, Result) :-
    foldl(merge_single, Count2, Count1, Result).

merge_single(C-N, Count, Result) :-
    nth0(Idx, Count, C-Prev, Rest),
    Next is Prev + N,
    append(Rest, [C-Next], Result), !;
    append(Count, [C-N], Result).
