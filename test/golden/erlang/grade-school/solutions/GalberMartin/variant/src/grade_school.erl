-module(grade_school).

-export([add/3, get/2, get/2, new/0]).


add(Name, Grade, School) ->
  CurrentNames = grade_school:get(School),
  case lists:member(Name, CurrentNames) of
    true -> School;
    false -> save_or_insert(Name, Grade, School)
  end.

save_or_insert(Name, Grade, School) ->
  Grades = maps:keys(School),
  case lists:member(Grade, Grades) of
    true -> maps:update(Grade, sets:to_list(sets:from_list(get(Grade, School) ++ [Name])), School);
    false -> maps:put(Grade, [Name], School)
  end.

get(Grade, School) ->
  maps:get(Grade, School, []).

get(School) ->
  Grades = maps:keys(School),
  AllNameList = lists:map(fun(Grade) -> get(Grade, School) end, Grades),
  sets:to_list(sets:from_list(lists:append(AllNameList))).

new() -> maps:new().
