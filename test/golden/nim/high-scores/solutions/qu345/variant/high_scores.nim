import std/algorithm

proc latest*(scores: openArray[int]): int =
  scores[scores.high]

proc personalBest*(scores: openArray[int]): int =
  max(scores)

proc personalTopThree*(scores: openArray[int]): seq[int] =
  scores.sorted(Descending)[1..min(2,scores.high)]
