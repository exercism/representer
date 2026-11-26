import sequtils, math, strutils

proc toInt(c: char): int =
  ord(c) - 48 # ord('0')

proc largestProduct*(input: string, numdigits: int): int =
  if numdigits == 0:
    return 1
  if numdigits < 0:
    raise newException(ValueError, "numdigits negative")
  if numdigits >= input.len:
    raise newException(ValueError, "numdigits larger than series length")
  if not input.allCharsInSet(Digits):
    raise newException(ValueError, "invalid series")

  let s = input.map(toInt)
  var maxProd = 0
  for i in 0..(s.len - numdigits):
    let currentProd = prod(s[i..<(i + numdigits)])
    if currentProd > maxProd: maxProd = currentProd
  maxProd
