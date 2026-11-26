convert(0, _, "") :- !.
convert(N, [A-B|Values], Numeral) :-
  N >= A -> NA is N - A, convert(NA, [A+B|Values], Numeral_), string_concat(B, Numeral_, Numeral);
  convert(N, Values, Numeral).

convert(N, Numeral) :-
  convert(N, [1000-"M", 900-"CM", 500-"D", 400-"CD", 100-"C", 90-"XC", 50-"L", 40-"XL", 10-"X", 9-"IX", 5-"V", 4-"IV", 1-"I"], Numeral).
