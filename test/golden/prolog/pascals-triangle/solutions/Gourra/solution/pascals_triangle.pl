pascal(Level, Rows) :-
  pascal(Level, [], Rows), !.

pascal(0, _, []) :- !.
pascal(Level, Row, [[1|NR]|Rows]) :-
  L1 is Level - 1,
  nextr(Row, NR),
  pascal(L1, [1|NR], Rows).

nextr([], []).
nextr([1], [1]).
nextr([X, Y|R], [Z|NR]) :-
  Z is X + Y,
  nextr([Y|R], NR).