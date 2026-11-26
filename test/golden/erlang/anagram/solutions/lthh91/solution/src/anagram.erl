-module(anagram).

-export([find_anagrams/2, are_anagrams/2]).


find_anagrams(_Subject, _Candidates) -> 
    lists:filter(fun(_Candidate) -> string:casefold(_Candidate) /= string:casefold(_Subject)
                                    andalso
                                    are_anagrams(string:casefold(_Subject),
                                                 string:casefold(_Candidate)) end,
                 _Candidates).

are_anagrams([], []) -> true;
are_anagrams(_, []) -> false;
are_anagrams([], _) -> false;
are_anagrams([H|T], _Compare) ->
    case lists:member(H, _Compare) of
        true -> are_anagrams(T, lists:delete(H, _Compare));
        false -> false
    end.
    
