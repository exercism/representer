import times

proc addGigasecond*(d: DateTime) : DateTime =
  d + initDuration(seconds = 1_000_000_000)
