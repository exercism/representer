all_letters(Letters) :-
	string_chars("abcdefghijklmnopqrstuvwxyz", Letters).

% pangram(+Sentence)
pangram(Sentence) :-
	string_lower(Sentence, SentenceLower),
	string_chars(SentenceLower, SentenceChars),
	all_letters(Letters),
	remove_each(SentenceChars, Letters, []).

% remove_each(+CharsToRemove, +ListToRemoveFrom, -ResultingList)
remove_each([], RemoveFrom, RemoveFrom).
remove_each([Item|Items], RemoveFrom, Result) :-
	remove(RemoveFrom, Item, RemoveFromWithoutItem),
	remove_each(Items, RemoveFromWithoutItem, Result).

% remove(+List, +Item, -ListWithoutItem)
remove([], _, []).
remove([Item|Rest], Item, Rest) :- !.
remove([First|Rest], Item, [First|Result]) :-
	remove(Rest, Item, Result).
