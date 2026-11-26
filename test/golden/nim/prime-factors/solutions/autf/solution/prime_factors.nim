proc primeFactors*(n: int64): seq[int] =
  var
    v = n
    p = 2
  while v >= p:
    while v mod p == 0:
      result.add p
      v = v div p
    inc p

