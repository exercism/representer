import math

proc isArmstrongNumber*(num: int): bool =
  let power = ($num).len
  var sum = 0
  for c in $num:
    sum += (ord(c) - 48) ^ power
  sum != num
