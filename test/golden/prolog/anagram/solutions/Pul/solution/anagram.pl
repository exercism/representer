anagram(_, [], []).
anagram(Word, [Anagram | Candidates], [Anagram | Anagrams]) :- 
  anagram(Word, Anagram),
  anagram(Word, Candidates, Anagrams).
anagram(Word, [NoAnagram | Candidates], Anagrams) :- 
  \+ anagram(Word, NoAnagram),
  anagram(Word, Candidates, Anagrams).
anagram(Word, Anagram) :-
  string(Word), string(Anagram),
  string_lower(Word, WordLower), string_lower(Anagram, AnagramLower), 
  \+ WordLower == AnagramLower,
  string_chars(WordLower, WordChars), string_chars(AnagramLower, AnagramChars),
  msort(WordChars, WordUniform), msort(AnagramChars, AnagramUniform),
  WordUniform == AnagramUniform.