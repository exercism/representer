next_letter(Word, Result) :- 
  sub_string(Word, 0, 2, _, Char),
  string_upper(Char, Result).

abb_list([], "").
abb_list([Word | Rest], Acc) :-
  abb_list(Rest, NextAcc),
  next_letter(Word, Letter),
  string_concat(Letter, NextAcc, Acc).

abbreviate(Sentence, Result) :-
  split_string(Sentence, " -", " _-", Words),
  abb_list(Words, Result).
