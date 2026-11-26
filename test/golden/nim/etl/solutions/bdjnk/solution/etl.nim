import tables, strutils

proc transform*(t: Table[int, seq[char]]): Table[char, int] =
  for count, characters in t.pairs:
    for character in characters:
      result[character.toLowerAscii] = count
