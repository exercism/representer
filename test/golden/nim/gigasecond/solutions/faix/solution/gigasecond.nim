import times
proc addGigasecond*(mom:DateTime ) : DateTime =
  mom+initDuration(seconds=1000000000)
