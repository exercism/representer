import times, math

proc addGigasecond*(d: DateTime): DateTime =
  d + (10^9).seconds
