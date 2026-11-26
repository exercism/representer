% Please visit https://exercism.io/tracks/prolog/installation
% for instructions on setting up prolog.
% Visit https://exercism.io/tracks/prolog/tests
% for help running the tests for prolog exercises.

% Replace the goal below with
% your implementation.

min_max(X):-
	X < 0, !, fail.
min_max(X):-
	X >= 7, !, fail.
min_max(_):-
	true.

create((X1, Y1)):-
	min_max(X1),
	min_max(Y1).

attack((X, _), (X, _)):- true, !.
attack((_, Y), (_, Y)):- true, !.
attack((X1, Y1), (X2, Y2)):-
	X is X1 - X2,
	Y is Y1 - Y2,
	abs(X) =:= abs(Y), !.
attack(_, _):- fail.
