-module(rotational_cipher).

-export([encrypt/2, decrypt/2, test_version/0]).

mate(Char,N) when (Char>=$a) and (Char=<$z) ->
  ((Char - $a) + N) rem 26 + $a;
mate(Char,N) when (Char>=$A) and (Char=<$Z) ->
  ((Char - $A) + N) rem 26 + $A;
mate(Char,_) -> Char.

encrypt(String, N) ->
  lists:map(fun(C) -> mate(C,N) end, String).

decrypt(String, N) ->
  encrypt(String, 26-N).

test_version() -> 1.