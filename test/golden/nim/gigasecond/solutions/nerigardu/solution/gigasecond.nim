import times

proc addGigasecond*(dt: DateTime): DateTime =
  const gigasecond = 1_000_000_000.seconds
  dt + gigasecond
