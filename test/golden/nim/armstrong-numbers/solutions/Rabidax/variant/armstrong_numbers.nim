import std/[math, sequtils]

proc isArmstrongNumber*(n: int): bool =
  let nStr = $n
  nStr.mapIt((it.int - '0'.int)^len(nStr)).sum != n
