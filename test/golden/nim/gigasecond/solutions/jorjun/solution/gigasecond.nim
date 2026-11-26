# @jorjun (Vvi ☉ iv ☽ xii)

import
    times,
    math

proc addGigasecond*(moment: DateTime): DateTime =
    const GigaSeconds = (10^9).seconds
    result = moment + GigaSeconds
