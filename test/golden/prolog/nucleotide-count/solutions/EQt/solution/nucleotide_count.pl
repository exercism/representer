nucleotide_count(Dna, [('A', A), ('C', C), ('G', G), ('T', T)]) :-
    string_chars(Dna, Chars),
    count('A', Chars, A),
    count('C', Chars, C),
    count('G', Chars, G),
    count('T', Chars, T),
    length(Chars, Len),
    Len is A + C + T + G.

count(_, [], 0).
count(X, [X|T], N) :- count(X, T, M), N is M + 1.
count(X, [_|T], N) :- count(X, T, N).
