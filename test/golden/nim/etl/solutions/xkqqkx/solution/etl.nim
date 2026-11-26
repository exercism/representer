import tables
type 
  OldScore = Table[int, seq[char]]
  NewScore = Table[char, int]

proc toLowerChar(c: char): char {.inline.} =
  let ordval = int(c)
  if 65 <= ordval and ordval <= 90:
    chr(int(c)+32)
  else:
    c

proc transform*(s:OldScore):NewScore =
  for k,v in s.pairs:
    for letter in v:
      result[toLowerChar(letter)] = k
