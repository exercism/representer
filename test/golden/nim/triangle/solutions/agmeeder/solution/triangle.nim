import sequtils

proc splitArray(sides: array[3, int]): tuple[a: int, b: int, c: int] =
  return (sides[0], sides[1], sides[2])

proc isTriangle(t: array[3, int]): bool =
  if t.allIt(it == 0): return false
  let (a, b, c) = splitArray(t)
  return a + b >= c and a + c >= b and b + b >= a

proc isEquilateral*(t: array[3, int]): bool =
  if isTriangle(t):
    let (a, b, c) = splitArray(t)
    return a == b and a == c
  return false

proc isIsosceles*(t: array[3, int]): bool =
  if isTriangle(t):
    let (a, b, c) = splitArray(t)
    return a == b or a == c or b == c
  return false

proc isScalene*(t: array[3, int]): bool =
  if isTriangle(t):
    let (a, b, c) = splitArray(t)
    return a != b and a != c and b != c
  return false
