convert(N, Numeral) :-
  loop(N, [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1], LoopList),
  atomics_to_string(LoopList, Numeral).

loop(_, [], []) :- !.

loop(N, [H|T], [H1|Acc]) :-
  H =< N ->
    map_numeral(H, H1),
    loop(N - H, [H|T], Acc);
    H1 = "",
    loop(N, T, Acc).

map_numeral(1000, "M").
map_numeral(900, "CM").
map_numeral(500, "D").
map_numeral(400, "CD").
map_numeral(100, "C").
map_numeral(90, "XC").
map_numeral(50, "L").
map_numeral(40, "XL").
map_numeral(10, "X").
map_numeral(9, "IX").
map_numeral(5, "V").
map_numeral(4, "IV").
map_numeral(1, "I").

