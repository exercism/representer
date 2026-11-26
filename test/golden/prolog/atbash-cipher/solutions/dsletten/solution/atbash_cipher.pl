alphanumeric([], []).
alphanumeric([C|Cs], [C|As]) :-
    char_type(C, alnum),
    alphanumeric(Cs, As).
alphanumeric([C|Cs], As) :-
    \+ char_type(C, alnum),
    alphanumeric(Cs, As).

encode(Plaintext, Chunked) :-
    atbash(Plaintext, Ciphertext),
    string_chars(Ciphertext, Cs),
    group(Cs, 5, Chunks),
    atomics_to_string(Chunks, " ", Chunked).

decode(Ciphertext, Plaintext) :-
    atbash(Ciphertext, Plaintext).

char_index(C, I) :-
    var(I), !,
    char_code(C, Cx),
    char_code(a, Ax),
    I is Cx - Ax.
char_index(C, I) :-
    var(C), !,
    char_code(a, Ax),
    Cx is I + Ax,
    char_code(C, Cx).

translate(C, C) :- \+ char_type(C, alpha).
translate(C, D) :-
    char_type(C, alpha),
    char_index(C, I),
    I1 is -(I + 1) mod 26,
    char_index(D, I1).

atbash(In, Out) :-
    string_lower(In, Lower),
    string_chars(Lower, Chars),
    alphanumeric(Chars, As),
    maplist(translate, As, Zs),
    string_chars(Out, Zs).

take_drop(L, 0, [], T) :- !, L = T.
take_drop([], _, [], []) :- !.
take_drop([H|T], N, [H|T1], T2) :- N1 is N-1, take_drop(T, N1, T1, T2).

group([], _, []) :- !.
group(Xs, N, [S|Chunks]) :-
    take_drop(Xs, N, H, T),
    string_chars(S, H),
    group(T, N, Chunks).
