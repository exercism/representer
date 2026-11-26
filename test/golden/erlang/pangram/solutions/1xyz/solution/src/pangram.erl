-module(pangram).

-export([is_pangram/1]).


is_pangram(Sentence) -> is_pangram(lists:seq($a,$z),string:to_lower(Sentence)).

is_pangram([],_Sentence)->true;
is_pangram([H|T],Sentence)->
case lists:member(H,Sentence) of
true->is_pangram(T,Sentence);
_ -> false
end.
