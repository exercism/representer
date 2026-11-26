let leap_year =
  let evenly_divisible year n = year mod n == 0 in
  function
  | year when evenly_divisible year 400 -> true
  | year when evenly_divisible year 100 -> false
  | year when evenly_divisible year 4 -> true
  | _ -> false