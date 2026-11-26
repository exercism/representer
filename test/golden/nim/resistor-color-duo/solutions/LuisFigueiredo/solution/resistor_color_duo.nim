



type Color* = enum
  Black, Brown, Red, Orange, Yellow,
  Green, Blue, Violet, Grey, White


proc value*(colors: openArray[Color]): int =
  colors[0].ord * 10 + colors[1].ord
