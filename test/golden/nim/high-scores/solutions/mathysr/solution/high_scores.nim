import algorithm, math

proc latest*(scores: seq[int]): int =
  if scores.len > 0: result = scores[^1]

proc personalBest*(scores: seq[int]): int =
  if scores.len > 0: result = max(scores)

proc personalTopThree*(scores: seq[int]): seq[int] = 
  result = scores
  result.sort(order = Descending)
  result = result[0 ..< min(3, scores.len)]
