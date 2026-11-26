local
  val SMALLS = [ "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eightteen", "nineteen"]

  val TENS = ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]
in
  fun say (number: int): string =
    if number < 0 orelse number > 999999999999 then raise Fail "input out of range"
    else if number < 20         then List.nth (SMALLS, number)
    else if number < 100        then saySmall number
    else if number < 1000       then sayCompound number 100 " hundred"
    else if number < 1000000    then sayCompound number 1000 " thousand"
    else if number < 1000000000 then sayCompound number 1000000 " million"
    else                             sayCompound number 1000000000 " billion"

  and saySmall (num: int): string =
    let val (n, r) = (num div 10, num mod 10)
    in  List.nth (TENS, n) ^ (if r = 0 then "" else "-" ^ say r)
    end
    
  and sayCompound num base word =
    let val (n, r) = (num div base, num mod base)
    in  say n ^ word ^ (if r = 0 then "" else " " ^ say r)
    end
end