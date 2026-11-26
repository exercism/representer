-- Month days (only February varies)
let month_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

-- Combined leap year check and days in month
def days_in_month (year: i32) (month: i32): i32 =
  let base = month_days[month - 1]
  in if month == 2 && ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) then 29 else base

-- Calculating for day of week
def day_of_week (year: i32) (month: i32) (day: i32): i32 =
  let (m, y) = if month <= 2 then (month + 12, year - 1) else (month, year)
  let h = (day + (13 * (m + 1)) / 5 + (y % 100) + (y % 100) / 4 + (y / 100) / 4 - 2 * (y / 100)) % 7
  in (h + 6) % 7

-- Generic weekday finder
def find_weekday (year: i32) (month: i32) (weekday_num: i32) (start: i32) (end: i32): i32 =
  let offset = (weekday_num - day_of_week year month start + 7) % 7
  let target = start + offset
  in if target <= end then target else -1

-- String to number mappings
def weekday_to_number (s: []u8): i32 =
  match (length s, s[0], if length s > 1 then s[1] else 'x', if length s > 2 then s[2] else 'x')
    case (6, 'S', 'u', 'n') -> 0
    case (6, 'M', 'o', 'n') -> 1
    case (7, 'T', 'u', 'e') -> 2
    case (9, 'W', 'e', 'd') -> 3
    case (8, 'T', 'h', 'u') -> 4
    case (6, 'F', 'r', 'i') -> 5
    case (8, 'S', 'a', 't') -> 6
    case _ -> -1

def week_to_number (s: []u8): i32 =
  match (length s, s[0], if length s > 1 then s[1] else 'x', if length s > 2 then s[2] else 'x')
    case (5, 'f', 'i', 'r') -> 1
    case (6, 's', 'e', 'c') -> 2
    case (5, 't', 'h', 'i') -> 3
    case (6, 'f', 'o', 'u') -> 4
    case (4, 'l', 'a', 's') -> -1
    case (6, 't', 'e', 'e') -> -2
    case _ -> 0

-- Date formatting
def format_date (year: i32) (month: i32) (day: i32): []u8 =
  let y = [u8.i32 (year / 1000 + '0'), u8.i32 ((year % 1000) / 100 + '0'), 
           u8.i32 ((year % 100) / 10 + '0'), u8.i32 (year % 10 + '0')]
  let m = [u8.i32 (month / 10 + '0'), u8.i32 (month % 10 + '0')]
  let d = [u8.i32 (day / 10 + '0'), u8.i32 (day % 10 + '0')]
  in [y[0], y[1], y[2], y[3], '-', m[0], m[1], '-', d[0], d[1]]

-- Main function
def meetup (year: i32) (month: i32) (week: []u8) (dayofweek: []u8): []u8 =
  let wd = weekday_to_number dayofweek
  let ws = week_to_number week
  let target = match ws
    case 1 -> find_weekday year month wd 1 (days_in_month year month)
    case 2 -> find_weekday year month wd 8 (days_in_month year month)
    case 3 -> find_weekday year month wd 15 (days_in_month year month)
    case 4 -> find_weekday year month wd 22 (days_in_month year month)
    case -1 -> let days = days_in_month year month in find_weekday year month wd (days - 6) days
    case -2 -> find_weekday year month wd 13 19
    case _ -> -1
  in format_date year month target
  