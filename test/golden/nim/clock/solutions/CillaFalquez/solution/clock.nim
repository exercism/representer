import strformat, math
type
  Clock* = object
    hour*: range[0..23]
    minute*: range[0..59]

  Minutes* = distinct int

proc initClock*(hour, minute: int): Clock =
  let inMinute = hour * 60 + minute
  Clock(hour: inMinute.euclDiv(60).euclMod(24), minute: inMinute.euclMod(60))

proc `$`*(c: Clock): string =
  &"{c.hour:02}:{c.minute:02}"

proc `+`*(c: Clock, v: Minutes): Clock =
  initClock(c.hour, c.minute + v.int())

proc `-`*(c: Clock, v: Minutes): Clock =
  initClock(c.hour, c.minute - v.int())
