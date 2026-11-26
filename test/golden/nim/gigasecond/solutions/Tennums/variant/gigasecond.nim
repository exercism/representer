import times

proc addGigasecond *(moment: DateTime): DateTime =
    const gigasecond = initTimeInterval(seconds=1_000_000_000)
    return moment - gigasecond