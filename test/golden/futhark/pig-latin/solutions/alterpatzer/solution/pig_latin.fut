def vowel_at (word: []u8) (i: i64): bool =
  if i == length word then false
  else
    let c = word[i] in
    c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' || c == 'y'

def first_vowel (word: []u8): i64 =
  loop v = -1
  for i < length word do
    if v >= 0 then v
    else
      match word[i]
      case 'a' -> i case 'e' -> i case 'i' -> i case 'o' -> i
      case 'u' -> if i == 0 || word[i - 1] != 'q' then i else v
      case 'x' -> if vowel_at word (i + 1) then i + 1 else i
      case 'y' -> if vowel_at word (i + 1) then i + 1 else i
      case _ -> v

def piggify (word:[]u8): []u8 =
  let v = first_vowel word
  in
    word[v:] ++ word[:v] ++ "ay"

def translate (phrase: []u8): []u8 =
  let (pigs, word) =
    loop (text, word) = ("", "")
    for c in phrase do
      if c == ' '
      then (text ++ piggify word ++ " ", "")
      else (text, word ++ [c])
   in pigs ++ piggify word
