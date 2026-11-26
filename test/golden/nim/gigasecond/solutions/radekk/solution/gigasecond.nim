import times

proc addGigasecond*(moment : DateTime) : DateTime =
    let unix = moment.toTime.toUnix
    let later = unix + 1000000000
    inZone(fromUnix(later), utc())
