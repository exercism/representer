type
  Action* = enum
    Wink, DoubleBlink, CloseEyes, Jump

proc commands*(decimal: int): seq[Action] =
  let reversed = (decimal and 16) != 0
  var num = decimal
  for i in 0..3:
    if (num and 1) == 1:
      if reversed: result.insert(Action(i), 0)
      else: result.add Action(i)
    num = num shr 1