-module(yacht).
-export([score/2]).

acc() -> #{1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0}.

score(Dice, Category) ->
  case Category of
    ones -> cal(Dice, 1);
    twos -> cal(Dice, 2);
    threes -> cal(Dice, 3);
    fours -> cal(Dice, 4);
    fives-> cal(Dice, 5);
    sixes -> cal(Dice, 6);
    full_house -> house(Dice);
    four_of_a_kind -> four(Dice);
    little_straight -> little(Dice);
    big_straight -> big(Dice);
    choice -> lists:sum(Dice);
    yacht -> fiveMatch(Dice);
    _ -> 0
  end.

house(Dice) ->
    Count = count(Dice, acc()),
    Logic = fun(_, V) -> V == 2 orelse V == 3 end ,
    FilteredMap = maps:filter(Logic, Count),
    LenThreeFreq = maps:filter(fun(_,V) -> V == 3 end, FilteredMap),
    case maps:size(FilteredMap) == 2 andalso maps:size(LenThreeFreq) == 1 of
      false -> 0;
      true ->
        begin
          FoldLogic = fun(K, V, Acc) -> (K * V) + Acc end,
          maps:fold(FoldLogic, 0, FilteredMap)
        end
    end.


big(Dice) ->
    Count = count(Dice, acc()),
    Logic = fun(_, V) -> V == 1 end,
    FilteredMap = maps:filter(Logic, Count),
    case maps:size(FilteredMap) == 5 andalso maps:get(1, Count) == 0 of
      true -> 30;
      false -> 0
    end.

little(Dice) ->
    Count = count(Dice, acc()),
    Logic = fun(_, V) -> V == 1 end,
    FilteredMap = maps:filter(Logic, Count),
    case maps:size(FilteredMap) == 5 andalso maps:get(6, Count) == 0 of
      true -> 30;
      false -> 0
    end.


fiveMatch(Dice) ->
    Count = count(Dice, acc()),
    Logic = fun(_, V) -> V == 5 end,
    FilteredMap = maps:filter(Logic, Count),
    case maps:size(FilteredMap) > 0 of
      true -> 50;
      false -> 0
    end.


four(Dice) ->
  Count = count(Dice, acc()),
  Logic = fun(_, V) -> V >= 4 end, 
  FilteredMap = maps:filter(Logic, Count),
  FoldLogic = fun(K, _, Acc) -> (K * 4) + Acc end,
  maps:fold(FoldLogic, 0, FilteredMap).

count(Dice, Acc) ->
  case Dice of
    [] -> Acc;
    [Head| Tail] ->
      begin
        NewMap = change(Head, Acc),
        count(Tail, NewMap)
      end
  end.

change(Num, Acc) ->
  Target = maps:get(Num, Acc),
  Acc#{Num := Target + 1}.

cal(Dice, Key) ->
  Count = count(Dice, acc()),
  Logic = fun(K, _) -> K == Key end,
  FiltredMap = maps:filter(Logic, Count),
  FoldLogic = fun(K, V, Acc) -> (K * V) + Acc end,
  maps:fold(FoldLogic, 0, FiltredMap).
