-module(anagram).

-export([find_anagrams/2]).


find_anagrams(_Subject, _Candidates) -> 
  case [Word || Word <- _Candidates, (lists:sort(string:lowercase(_Subject)) == lists:sort(string:lowercase(Word))) and (string:lowercase(_Subject) /= string:lowercase(Word))] of
    Word -> Word
  end.