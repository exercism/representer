proc primeFactors*(n: int64): seq[int] =
  if n < 2: return @[]
  var m = n
  while m > 1:
    for i in 2..n:
      if m mod i == 0:
        result.add(i)
        m = m div i
        break
