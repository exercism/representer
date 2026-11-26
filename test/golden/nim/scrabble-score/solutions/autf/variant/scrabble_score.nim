import sequtils, strutils, math

proc score*(word: string): int =
  word.mapIt(
    case it.toUpperAscii:
    of 'D', 'G': 2
    of 'B', 'C', 'M', 'P': 3
    of 'F', 'H', 'V', 'W', 'Y': 4
    of 'K': 5
    of 'J', 'X': 9
    of 'Q', 'Z': 10
    else: 1
  ).sum
