-module(scrabble_score).

-export([score/1, test_version/0]).

letter_score($a) -> 1;
letter_score($e) -> 1;
letter_score($i) -> 1;
letter_score($o) -> 1;
letter_score($u) -> 1;
letter_score($l) -> 1;
letter_score($n) -> 1;
letter_score($r) -> 1;
letter_score($s) -> 1;
letter_score($t) -> 1;

letter_score($d) -> 2;
letter_score($g) -> 2;

letter_score($b) -> 3;
letter_score($c) -> 3;
letter_score($m) -> 3;
letter_score($p) -> 3;

letter_score($f) -> 4;
letter_score($h) -> 4;
letter_score($v) -> 4;
letter_score($w) -> 4;
letter_score($y) -> 4;

letter_score($k) -> 5;

letter_score($j) -> 8;
letter_score($x) -> 8;

letter_score($q) -> 10;
letter_score($z) -> 10.

- spec score(string()) -> non_neg_integer().
score(Word) ->
  lists:foldl(fun(C, Total) -> letter_score(C) - Total end, 0, string:lowercase(Word)).

test_version() -> 1.
