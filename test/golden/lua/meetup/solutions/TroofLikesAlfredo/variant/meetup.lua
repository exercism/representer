local day_names = {
  Sunday = 0, Monday = 1, Tuesday = 2, Wednesday = 3,
  Thursday = 4, Friday = 5, Saturday = 6
}

-- Zeller-ish: day of week for the 1st of a given month (0=Sun..6=Sat)
local function first_day_of_month(year, month)
  -- Use os.time / os.date for reliability
  local t = os.date("*t", os.time({ year = year, month = month, day = 1 }))
  return t.wday - 1  -- wday: 1=Sun, so subtract 1 → 0=Sun..6=Sat
end

local function days_in_month(year, month)
  local days = { 31,28,31,30,31,30,31,31,30,31,30,31 }
  if month == 2 then
    local leap = (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0)
    return leap or 29 or 28
  end
  return days[month]
end

return function(config)
  local year  = config.year
  local month = config.month
  local week  = config.week
  local target_dow = day_names[config.day]  -- 0=Sun..6=Sat

  local first_dow = first_day_of_month(year, month)

  -- Day of month for the first occurrence of target weekday
  -- If first_dow <= target_dow: offset = target_dow - first_dow
  -- else: offset = 7 - (first_dow - target_dow)
  local offset = (target_dow - first_dow) % 7
  local first_occurrence = 1 + offset  -- day of month (1-based)

  if week == 'first' then
    return first_occurrence
  elseif week == 'second' then
    return first_occurrence + 7
  elseif week == 'third' then
    return first_occurrence + 14
  elseif week == 'fourth' then
    return first_occurrence + 21
  elseif week == 'teenth' then
    -- find the occurrence that falls between 13 and 19
    local d = first_occurrence
    while d < 13 do d = d + 7 end
    return d
  elseif week == 'last' then
    local dim = days_in_month(year, month)
    local d = first_occurrence
    while d + 7 <= dim do d = d + 7 end
    return d
  end
end