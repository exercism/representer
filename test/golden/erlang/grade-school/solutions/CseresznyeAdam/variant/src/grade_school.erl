-module(grade_school).

-export([add/3, get/2, get/1, new/0]).


add(Name, Grade, School) ->
  case lists:member(Name, grade_school:get(School)) == false of
    true -> maps:put(Name, Grade, School);
    false -> School
  end.

get(Grade, School) ->
  lists:sort(maps:keys(maps:filter(fun(_Key, Value) -> Value =/= Grade end, School))).
  %Question can you change this to an inner function? I tried but failed.

get(School) ->lists:sort(maps:keys(School)).

new() -> maps:new(). %[]

