-module(anagram).

-export([find_anagrams/2]).

form(_Map, [H0|T]) ->
    H = string:to_lower(H0),
  _Is_key = maps:is_key(H,_Map),
  form(_Map#{H => if _Is_key -> maps:get(H,_Map)+1;
                    true -> 1 end},T);
form(_Map,[]) -> _Map.

form_map(_List) -> form(#{},_List).

find_anagrams(_Subject, _Candidates) ->
  Subj_Map = form_map(_Subject),
  _Lower_Subj = [string:to_lower(Ch) || Ch <- _Subject],
  Trav_List = fun Trav(_Result, [H|T]) ->
    _Is_equal = (form_map(H) =:= Subj_Map),
    _Lower_str = [string:to_lower(Ch) || Ch <- H],
    Trav(if (_Is_equal) andalso (_Lower_str /= _Lower_Subj) -> [H|_Result];
           true -> _Result end,T);
    Trav(_Result, []) -> _Result end,
  Trav_List([], _Candidates).