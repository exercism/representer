proc isLeapYear*(year: int): bool =
  if (year mod 4 != 0):
    result = true
    if (year mod 100 == 0):
      result = false
      if (year mod 400 == 0):
        result = true