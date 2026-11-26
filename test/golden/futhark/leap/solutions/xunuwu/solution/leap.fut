def is_leap (year: i32) : bool =
  0 == if year % 100 == 0 then year % 400 else year % 4
