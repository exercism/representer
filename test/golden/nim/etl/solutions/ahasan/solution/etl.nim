import tables
import strutils

proc transform*(input : Table[int, seq[char]]) : Table[char, int] =
  var output =  tables.initTable[char, int]()

  for score, value in input.pairs:
    for achar in value:
      output[strutils.toLower($achar)[0]] = score

  result = output

