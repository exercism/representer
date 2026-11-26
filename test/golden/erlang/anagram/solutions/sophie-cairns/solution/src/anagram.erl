-module(anagram).

-export([find_anagrams/2]).

find_anagrams(Subject, Candidates) -> find_anagrams(Subject, Candidates, []).


find_anagrams(Subject, [], Ans) -> Ans;
find_anagrams(Subject, [H|T], Ans) ->
    Sub = string:lowercase(Subject),
    Can = string:lowercase(H),
    S = lists:sort([X || X <- Sub]),
    C = lists:sort([Y || Y <- Can]),
    if Sub /= Can andalso S == C ->
            find_anagrams(Subject, T, [H|Ans]);
        true ->
            find_anagrams(Subject, T, Ans)
        end.
