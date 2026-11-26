from math import sum

type
  Aliquot* = enum
    Deficient,
    Perfect,
    Abundant

proc factors(n: int): seq[int] =
  for i in 1..(n.div(2) + 1):
    if n.mod(i) == 0:
      result.add(i)

proc compare(num, alsum: int): Aliquot =
  if alsum < num: Deficient
  elif num == alsum: Perfect
  else: Abundant

proc classify*(n: int): Aliquot =
  if n < 1: raise newException(ValueError, "invalid number")
  if n in {1, 2}: return Deficient
  let aliquot = n.factors.sum
  compare(n, aliquot)
