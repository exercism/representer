sublist([], _).
sublist([X|Xs], [X|Ys]) :- sublist(Xs, Ys).
sublist([X|Xs], [_|Ys]) :- sublist([X|Xs], Ys).

combinations(Size, Sum, Exclude, Combinations) :-
  findall(N, between(1, 10, N), Numbers),
  ord_subtract(Numbers, Exclude, AcceptedNumbers),
  findall(Combination, (sublist(Combination, AcceptedNumbers), sumlist(Combination, Sum), length(Combination, Size)), Combinations).
