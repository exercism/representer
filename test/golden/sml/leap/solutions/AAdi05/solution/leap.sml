fun isLeapYear year =
  let
    fun divisible n = year mod n = 0
  in 
    (divisible 4 andalso not(divisible 100)) orelse divisible 400
  end