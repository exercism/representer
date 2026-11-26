import tables, strutils


proc transform*(input: Table[int, seq[char]]): Table[char, int] =
  result = initTable[char, int]()
  for index, chSeq in input:
    for ch in chSeq:
      result[ch.toLowerAscii] = index