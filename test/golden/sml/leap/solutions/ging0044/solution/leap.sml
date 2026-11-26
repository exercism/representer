fun isLeapYear year =
  let fun divisible n = year mod n = 0
  in
    case (divisible 4, divisible 100, divisible 400) of
         (true, false, false) => true
       | (true, true, true) => true
       | _ => false
  end
