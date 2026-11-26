stop("UAA").
stop("UAG").
stop("UGA").

tran("AUG", "Methionine").
tran("UUU", "Phenylalanine").
tran("UUC", "Phenylalanine").
tran("UUA", "Leucine").
tran("UUG", "Leucine").
tran("UCU", "Serine").
tran("UCC", "Serine").
tran("UCA", "Serine").
tran("UCG", "Serine").
tran("UAU", "Tyrosine").
tran("UAC", "Tyrosine").
tran("UGU", "Cysteine").
tran("UGC", "Cysteine").
tran("UGG", "Tryptophan").

triple1(S, T) :-
    string_length(S, Ln),
    UBound is Ln - 3,
    between(0, UBound, I),
    0 is I mod 3,
    sub_string(S, I, 3, _, T).

triple(S, T) :-
    triple1(S, Tmp),
    (   stop(Tmp)
    ->  !, fail
    ;   T = Tmp
    ).

protein(S, P) :-
    triple(S, T),
    tran(T, P).

translate(Rna, Proteins) :-
    findall(P, protein(Rna, P), Proteins).
