update leap
set is_leap = year % 4 = 0 or (year % 100 != 0 or year % 400 = 0);