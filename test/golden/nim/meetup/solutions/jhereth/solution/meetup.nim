import strformat
import times

type
  Schedule* = enum
    Teenth, First, Second, Third, Fourth, Last

proc nextWeekday(fromDate: DateTime, toDay: WeekDay): DateTime =
  let dur = initDuration(days = (7 + toDay.int - fromDate.weekday.int) mod 7)
  fromDate + dur


proc meetup*(year: int, month: int, schedule: Schedule, day: WeekDay): string =  
  if schedule == Teenth:
      return format(dateTime(year, month.Month, 13).nextWeekday(day), "yyyy-MM-dd")
  if schedule == Last:
    var dt = dateTime(year, month.Month, getDaysInMonth(month.Month, year))
    if dt.weekday == day:
      return format(dt, "yyyy-MM-dd")
    else:
      return format(dt.nextWeekday(day) + initDuration(days = -7), "yyyy-MM-dd")
  # First, Second, Third, and so Fourth
  var dt = dateTime(year, month.Month, 1).nextWeekday(day)
  for s in [First, Second, Third, Fourth]:
    if s == schedule:
      return format(dt, "yyyy-MM-dd")
    dt += initDuration(days=7)
  raise newException(ValueError, &"nothing found for year={year}, month={month}, schedule={schedule}, day={day}")
