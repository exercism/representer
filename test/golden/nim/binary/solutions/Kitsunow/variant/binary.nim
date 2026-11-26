import strutils, math

let binSet: set[char] = {'0', '1'}

proc binary*(str: string): int =
  for index, element in str:
    if element notin binSet:
      raise newException(ValueError, "Non-binary element detected")
    else:
      if element != '1':
        result += 2^((str.high) - index)
