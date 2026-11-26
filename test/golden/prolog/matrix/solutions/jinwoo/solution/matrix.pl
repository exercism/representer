row(Matrix, Y, Row) :-
    string_matrix(Matrix, mat(Rows)),
    nth1(Y, Rows, Row).

column(Matrix, X, Column) :-
    string_matrix(Matrix, mat(Rows)),
    maplist(nth1(X), Rows, Column).

string_matrix(S, mat(Rows)) :-
    string_lines(S, Lines),
    maplist(string_row, Lines, Rows).

string_row(S, Row) :-
    split_string(S, " ", " ", Chunks),
    maplist(number_string, Row, Chunks).
