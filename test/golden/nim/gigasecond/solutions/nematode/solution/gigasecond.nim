import times

const interval: Duration = initDuration(seconds = 1000000000)

proc addGigasecond*(dt1:DateTime): DateTime =
  ## dt1 is starting moment. return dt1 plus 10^9 seconds
  result = dt1 + interval
  return
