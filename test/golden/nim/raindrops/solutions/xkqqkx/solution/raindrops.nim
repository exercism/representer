import tables,strutils
const sounds = {3:"Pling", 5:"Plang", 7:"Plong"}.toTable

proc convert*(n:int): string =
  var
    words: seq[string]
  for k in sounds.keys:
    if n mod k == 0:
      words.add(sounds[k])
  if len(words) == 0:
    return $n
  else:
    return words.join
