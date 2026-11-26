% Exercism - ETL

transform(ScoreLetters, LetterScores) :-
  findall(Atom-Score, (
    member(Score-LetterList, ScoreLetters),
    member(Char, LetterList),
    downcase_atom(Char, Atom)
  ), Unsorted),
  sort(Unsorted, LetterScores).