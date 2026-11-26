-module(anagram).

-export([find_anagrams/2]).


find_anagrams(Subject, Candidates) -> find_anagrams(string:casefold(Subject), Candidates, []).

find_anagrams(_, [], Matches) -> lists:reverse(Matches);
find_anagrams(Subject, [H | T], Matches) ->
	case string:casefold(H) of
		Subject -> find_anagrams(Subject, T, Matches);
		Candidate ->
			case lists:sort(Candidate) =:= lists:sort(Subject) of
				true -> find_anagrams(Subject, T, [H | Matches]);
				false -> find_anagrams(Subject, T, Matches)
			end
	end.