import times

proc addGigasecond*(moment: DateTime): DateTime =
  moment + initDuration(seconds = 1_000_000_000)
