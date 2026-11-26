import tables
import strutils

func transform*(scores: Table[int, seq[char]]): Table[char, int] =
  for score, chars in scores.pairs:
    for c in chars:
      result[c.toLowerAscii] = score
