-module(all_your_base).

-export([rebase/3]).
rebase(_, Base, _)  when Base <2 -> {error,"input base must be >= 2"};
rebase(_, _, NewBase)  when NewBase <2 -> {error,"output base must be >= 2"};
rebase([], _, _) -> {ok,[0]};
rebase([0], _, _) -> {ok,[0]};


rebase(Number, Base, Newbase) ->


  Value = base10(Number, Base, 0),
  case Value of 
  error -> {error,"all digits must satisfy 0 <= d < input base"};
   _->  convert(trunc(Value), Newbase, [])
  end.

convert(0, _ , [])->{ok,[0]};
convert(0, _, Resultlist) -> {ok,Resultlist};
convert(Value, Base, Resultlist) ->
  New_value = (Value div Base),
  convert(New_value, Base, [Value rem Base | Resultlist]).

base10([], _, Sum) -> Sum;
base10(Number, Base, Sum) when (hd(Number) >= 0) andalso (hd(Number) < Base) ->
    base10(tl(Number), Base, (Sum*Base + hd(Number)));
base10(_, _, _)    -> error.
