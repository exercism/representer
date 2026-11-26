proc steps*(n: int): int =
  if n <= 0:
    raise newException(ValueError, "kpd")

  var a = n
  while a > 1:
    if a mod 2 == 0:
      a = (a / 2).toInt
    else:
      a = 3*a+1
    result += 1