-module(forth).

-export([evaluate/1]).


evaluate(Instructions) -> evaluate(Instructions, #{}).

evaluate([Instruction], Defs) ->
  Segments = string:split(string:lowercase(Instruction), " ", all),
  process(Segments, Defs, []);
evaluate([H|T], Defs) ->
  NewDefs = update_defs(string:lowercase(H), Defs),
  evaluate(T, NewDefs).

process([], _Defs, Stack) -> lists:reverse(Stack);
process([H|T], Defs, Stack) ->
  case maps:get(H, Defs, undefined) of
    undefined -> process(T, Defs, update_stack(H, Stack));
    Value -> process(Value ++ T, Defs, Stack)
  end.

update_defs(Instruction, Defs) ->
  [Key|Values] = string:split(string:trim(Instruction, both, ":; "), " ", all),
  ResolvedValues = [maps:get(V, Defs, V) || V <- Values],
  maps:put(Key, ResolvedValues, Defs).

update_stack("+", [A,B|T]) -> [B+A|T];
update_stack("-", [A,B|T]) -> [B-A|T];
update_stack("*", [A,B|T]) -> [B*A|T];
update_stack("/", [A,B|T]) -> [B div A|T];
update_stack("dup", [A|T]) -> [A,A|T];
update_stack("drop", [_|T]) -> T;
update_stack("swap", [A,B|T]) -> [B,A|T];
update_stack("over", [A,B|T]) -> [B,A,B|T];
update_stack(Val, Stack) ->
  case string:to_integer(Val) of
    {error, _} -> erlang:error(badarg);
    {Number, _} -> [Number|Stack]
  end.
