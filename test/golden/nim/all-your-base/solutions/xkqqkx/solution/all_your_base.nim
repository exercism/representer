import algorithm,math, sequtils

proc toValue(inputDigits: openArray[int], inputBase:int): int = 
  for pos, d in reversed(inputDigits):
    result += d*(inputBase^pos)


proc fromValue(value, outputBase: int): seq[int] =

  if value == 0:
    return @[0]

  var
    d = 0
    v = value
  while v != 0:
    d = v mod outputBase
    v = v div outputBase
    result.add(d)
  return reversed(result)


proc convert*(inputDigits: openArray[int], inputBase, outputBase: int): seq[int] =

  if any(inputDigits, proc (e:int): bool = e >= inputBase or e < 0):
    raise new ValueError

  if inputBase < 2 or outputBase < 2:
    raise new ValueError

  if len(inputDigits) == 0:
    return @[0]

  let v = toValue(inputDigits, inputBase)
  return fromValue(v, outputBase)

