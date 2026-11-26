include std/convert.e
include std/math.e

public function is_armstrong_number(integer number)
  sequence digits = to_string(number) - '1'
  return number = sum(power(digits, length(digits)))
end function
