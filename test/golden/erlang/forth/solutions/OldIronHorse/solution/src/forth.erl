-module(forth).

-export([evaluate/1]).


evaluate(Instructions) ->
  lists:reverse(
    evaluate(
      string:lexemes(string:lowercase(lists:join(" ", Instructions)), " "),
      builtins(),
      [])).

evaluate([], _, Stack) -> Stack;
evaluate([":", Name|Is], Words, Stack) ->
  case string:to_integer(Name) of
    {error, no_integer} ->
      {Definition, [";"|Iss]} = lists:splitwith(fun(T) -> T =/= ";" end, Is),
      evaluate(
        Iss,
        [{Name, fun(Ws, Ss) -> evaluate(Definition, Ws, Ss) end}|Words],
        Stack);
    _ -> erlang:error(invalid_name)
  end;
evaluate([I|Is], Words, Stack) ->
  case string:to_integer(I) of
    {error, no_integer} ->
      case lists:dropwhile(fun({Name, _}) -> Name =/= I end, Words) of
        [] -> erlang:error(unknown_word);
        [{_, Op}|Ws] -> evaluate(Is, Words, Op(Ws, Stack))
      end;
    {N, _} -> evaluate(Is, Words, [N|Stack])
  end.

builtins() -> [
               {"dup", fun(_, [N|Stack]) -> [N|[N|Stack]] end},
               {"drop", fun(_, [_|Stack]) -> Stack end},
               {"swap", fun(_, [First, Second|Stack]) ->
                            [Second|[First|Stack]] end},
               {"over", fun(_, [First, Second|Stack]) ->
                            [Second|[First|[Second|Stack]]] end},
               {"+", fun(_, [Rhs, Lhs|Stack]) -> [Lhs + Rhs|Stack] end},
               {"-", fun(_, [Rhs, Lhs|Stack]) -> [Lhs - Rhs|Stack] end},
               {"*", fun(_, [Rhs, Lhs|Stack]) -> [Lhs * Rhs|Stack] end},
               {"/", fun(_, [Rhs, Lhs|Stack]) -> [Lhs div Rhs|Stack] end}
              ].

