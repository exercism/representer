import times, math

##
## demo to show how to do calculations like these
## without support from the times module in the stdlib
##

const OneDay = 86400
const gigaSecond = 10^9

proc isLeapYear*(year: int): bool =
  return (floorMod(year, 4) == 0) and (floorMod(year, 400) notin {100, 200, 300})

proc toOrdinalFromYMD*(year, month, day: int): int =
  ##| return the ordinal day number in the proleptic gregorian calendar
  ##| 0001-01-01 is day number 1
  ##| algorithm from CommonLisp calendrica-3.0
  ##
  result = 0
  result += (365 * (year - 1))
  result += floorDiv(year - 1, 4)
  result -= floorDiv(year - 1, 100)
  result += floorDiv(year - 1, 400)
  result += floorDiv((367 * month) - 362, 12)
  if month <= 2:
      result += 0
  else:
      if isLeapYear(year):
          result -= 1
      else:
          result -= 2
  result += day

proc toSeconds*(dt: DateTime): int =
  ##| return number of Seconds 
  ##| since 0001-01-01T00:00:00
  ##
  result = toOrdinalFromYMD(dt.year, dt.month.int, dt.monthday) * OneDay
  result += dt.hour * 60 * 60
  result += dt.minute * 60
  result += dt.second


proc yearFromOrdinal*(ordinal: int): int =
  ##| Return the Gregorian year corresponding to the gregorian ordinal.
  ##| algorithm from CommonLisp calendrica-3.0
  ##
  let d0   = ordinal - 1
  let n400 = floorDiv(d0, 146097)
  let d1   = floorMod(d0, 146097)
  let n100 = floorDiv(d1, 36524)
  let d2   = floorMod(d1, 36524)
  let n4   = floorDiv(d2, 1461)
  let d3   = floorMod(d2, 1461)
  let n1   = floorDiv(d3, 365)
  let year = (400 * n400) + (100 * n100) + (4 * n4) + n1
  if n100 == 4 or n1 == 4:
    return year
  else:
    return year + 1


proc YMDfromOrdinal*(ordinal: int): tuple[year, month, day: int] =
  ##| Return Year, Month, Day corresponding to the gregorian ordinal.
  ##| algorithm from CommonLisp calendrica-3.0
  ##
  let year = yearFromOrdinal(ordinal)
  let prior_days = ordinal - toOrdinalFromYMD(year, 1, 1)
  var correction: int
  if (ordinal < toOrdinalFromYMD(year, 3, 1)):
    correction = 0
  else:
    if isLeapYear(year):
      correction = 1
    else:
      correction = 2
  let month = floorDiv((12 * (prior_days + correction)) + 373, 367)
  let day = int(1 + (ordinal - toOrdinalFromYMD(year, month, 1)))
  result.year = year
  result.month = month
  result.day = day


proc fromSeconds*(seconds: int): DateTime =
  ##| return DateTime from number of seconds since 0001-01-01T00:00:00
  ##
  let (year, month, day) = YMDfromOrdinal(floorDiv(seconds, OneDay))
  var tmp = floorMod(seconds, OneDay)
  let hour = floorDiv(tmp, 3600)
  tmp = floorMod(tmp, 3600)
  let minute = floorDiv(tmp, 60)
  tmp = floorMod(tmp, 60)
  let second = tmp
  result = initDateTime(year = year, month = Month(month), monthday = day,
                        hour = hour, minute = minute, second = second,
                        zone = utc())


proc addGigaSecond*(dt: DateTime): DateTime =
  let seconds = toSeconds(dt) + gigaSecond
  return fromSeconds(seconds)