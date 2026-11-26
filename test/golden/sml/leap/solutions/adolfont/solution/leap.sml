fun isLeapYear year =
    let 
        fun divisible_by number_of_years = year mod number_of_years = 0
    in 
      divisible_by 4 andalso 
      (divisible_by 400  orelse not (divisible_by  100))
   end    

