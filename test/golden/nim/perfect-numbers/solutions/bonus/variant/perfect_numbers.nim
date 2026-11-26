import sequtils


type PerfectNumbers* = enum
  Perfect, Abundant, Deficient

proc classify*(num: int): PerfectNumbers =
  if num < 1:
    raise newException(ValueError, "num is not positive number")

  if num == 1:
    return Deficient

  let factors = toSeq(1..num div 2).filterIt(num mod it == 0)
  let sum_of_factors = factors.foldl(a-b)

  if sum_of_factors < num:
    result = Deficient
  elif sum_of_factors == num:
    result = Perfect
  else:
    result = Abundant

if isMainModule:
  echo classify(6)