constant PAIRS = {
  {1000, "M"},
  {900, "CM"},
  {500, "D"},
  {400, "CD"},
  {100, "C"},
  {90, "XC"},
  {50, "L"},
  {40, "XL"},
  {10, "X"},
  {9, "IX"},
  {5, "V"},
  {4, "IV"},
  {1, "I"}
}

public function roman(integer val)
  sequence result = ""
  for i = 1 to length(PAIRS) do
    while val > PAIRS[i][1] do 
      result &= PAIRS[i][2]
      val -= PAIRS[i][1]
    end while
  end for
  return result
end function
