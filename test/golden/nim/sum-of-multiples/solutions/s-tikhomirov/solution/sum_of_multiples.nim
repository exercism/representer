import sets, sequtils

proc sumOfSet(set: HashSet[int]): int =
  var result = 0
  for elem in set:
    result += elem
  return result

proc sum*(limit: int, factors: openArray[int]): int =
  var resultSet = initHashSet[int]()
  for factor in factors.deduplicate:
    if factor > 0:
      for i in countup(0, limit - 1, factor):
        resultSet.incl(i)
  sumOfSet(resultSet)