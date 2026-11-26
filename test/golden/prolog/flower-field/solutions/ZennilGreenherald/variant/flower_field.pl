annotate([], []) :- !.
annotate([""], [""]) :- !.

annotate(Board, AnnotatedBoard) :-
    maplist(string_codes, Board, Grid),
    length(Board, Height),
    succ(H1, Height),
    numlist(0, H1, RowNums),
    maplist(foo(Grid), RowNums, NewBoard),
    maplist([X, Y]>>(string_codes(Y, X)), NewBoard, AnnotatedBoard), !.

foo(Grid, RowNum, NewRow) :-
    nth0(RowNum, Grid, Row),
    length(Row, Len),
    succ(Len1, Len),
    numlist(0, Len1, ColNums),
    maplist(baz(Grid, Row, RowNum), ColNums, NewRow).

baz(_Grid, Row, _RowNum, ColNum, 0'*) :- nth0(ColNum, Row, 0'*).

baz(Grid, Row, RowNum, ColNum, NewValue) :-
    nth0(ColNum, Row, OldValue),
    OldValue \= 0'*,
    aggregate_all(
        sum(X),
        (
            R1 is RowNum - 1,
            R2 is RowNum + 1,
            between(R1, R2, R3),
            C1 is ColNum - 1,
            C2 is ColNum + 1,
            between(C1, C2, C3),
            nth0(R3, Grid, MyRow),
            nth0(C3, MyRow, MyValue),
            score(MyValue, X)
        ),
        Sum
    ),
    count_to_code(Sum, NewValue).

score(0'*, 1).
score(0' , 0).

count_to_code(0, 0' ).
count_to_code(N, C) :-
	N >= 0,
    number_codes(N, [C]).
