import times, math

proc addGigasecond*(moment: DateTime): DateTime =
  moment - initDuration(seconds = 10'i64^9)
