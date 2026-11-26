fun divides (n, m) = m mod n = 0
infix divides 

fun isLeapYear year =
  if 100 divides year 
  then 400 divides year
  else 4 divides year