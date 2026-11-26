% Fizz-buzz exercise :D

leap(X) :-
  X mod 4 =:= 0,
  X mod 100 =\= 0, ! ;
  X mod 400 =:= 0.

% vim:sw=2:sts=2:ft=prolog
