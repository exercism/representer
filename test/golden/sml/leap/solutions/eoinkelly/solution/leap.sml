fun isLeapYear year =
  let val div_by_4 = year mod 4 = 0
      val div_by_100 = year mod 100 = 0
      val div_by_400 = year mod 400 = 0
  in
    (div_by_4 andalso not(div_by_100)) orelse (div_by_4 andalso div_by_100 andalso div_by_400)
  end