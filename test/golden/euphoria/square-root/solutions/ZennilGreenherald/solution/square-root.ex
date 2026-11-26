public function squareRoot(integer radicand)
  integer min = 1
  integer max = radicand
  while min + 1 < max do
    integer guess = min + floor((max - min) / 2)
    if guess * guess = radicand then
      min = guess
      max = guess
    elsif guess * guess < radicand then
      min = guess
    else
      max = guess
    end if
  end while
  return min
end function
