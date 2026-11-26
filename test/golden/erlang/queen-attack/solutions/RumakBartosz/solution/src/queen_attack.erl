-module(queen_attack).

-export([can_attack/2]).


can_attack({Horizontal, _}, {Horizontal, _}) -> true;
can_attack({_, Vertical}, {_, Vertical}) -> true;

can_attack({XWhite, YWhite}, {XBlack, YBlack}) ->
  if
    XWhite - YWhite =:= XBlack - YBlack -> true;
    XWhite + YWhite =:= XBlack + YBlack -> true;
    true -> false
  end.
