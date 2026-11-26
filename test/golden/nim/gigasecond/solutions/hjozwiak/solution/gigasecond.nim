import times
proc addGigasecond*(now: DateTime): DateTime =
  now+initDuration(seconds=1000000000)
