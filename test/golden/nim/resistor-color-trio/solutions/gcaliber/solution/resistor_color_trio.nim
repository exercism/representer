import std/math
  
type
  ResistorColor* = enum
    Black, Brown, Red, Orange, Yellow, Green, Blue, Violet, Grey, White

proc label*(r: array[3, ResistorColor]): tuple[value: int, unit: string] =
  var value = (r[0].ord * 10 + r[1].ord) * 10 ^ r[2].ord
  
  if value >= 1_000_000_000:
    value = value div 1_000_000_000
    return (value, "gigaohms")
  elif value >= 1_000_000:
    value = value div 1_000_000
    return (value, "megaohms")
  elif value >= 1_000:
    value = value div 1_000
    return (value, "kiloohms")
  else:
    return (value, "ohms")
