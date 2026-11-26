import std/times

proc addGigasecond*(dt: DateTime): DateTime =
  dt + initDuration(seconds = 1_000_000_000)
