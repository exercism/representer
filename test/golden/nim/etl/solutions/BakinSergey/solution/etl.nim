import std/tables, sugar, strutils

proc transform*(t: Table[int, seq[char]]): Table[char, int] =
  for k, v in t:
    for e in v:
      result[e.toLowerAscii] = k