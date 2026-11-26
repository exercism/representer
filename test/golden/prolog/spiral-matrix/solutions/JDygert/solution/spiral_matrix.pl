spiral(N, Spiral) :-
    findall(
        Row,
        (
            between(1, N, I),
            findall(E, (between(1, N, J), value_at(N, N, I, J, E)), Row)
        ),
        Spiral
    ).

value_at(W, H, I, J, Elem) :-
    (  I =:= 1
    -> Elem is J
    ;  value_at(H-1, W, W - J + 1, I - 1, Other), Elem is W + Other).