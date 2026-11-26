%row(+MatrixString, ?Y, ?Row)
row(MatrixString, Y, Row) :-
	string_matrix(MatrixString, Matrix),
	index_of(Row, Matrix, Y).

%column(+MatrixString, ?X, ?Column)
column(MatrixString, X, Column) :-
	string_matrix(MatrixString, Matrix),
	maplist({X}/[Row,Item] >> index_of(Item, Row, X), Matrix, Column).

%string_matrix(+String, -Matrix)
string_matrix(String, Matrix) :-
	split_string(String, "\n", " ", Rows),
	maplist(string_numbers, Rows, Matrix).

%string_numbers(+String, -Numbers)
string_numbers(String, Numbers) :-
	split_string(String, " ", " ", Items),
	maplist(string_number, Items, Numbers).

%string_number(?String, ?Number)
string_number(String, Number) :-
	number_string(Number, String).

%index_of(?Item, +List, ?Index)
index_of(Item, List, Index) :-
	index_of(Item, List, 1, Index).

%index_of(?Item, +List, +CurrIndex, ?Index)
index_of(Item, [Item|_], CurrIndex, CurrIndex) :- !.
index_of(Item, [_|Rest], CurrIndex, Index) :- !,
	NextIndex is CurrIndex + 1,
	index_of(Item, Rest, NextIndex, Index).
index_of(_, [], _, -1).
