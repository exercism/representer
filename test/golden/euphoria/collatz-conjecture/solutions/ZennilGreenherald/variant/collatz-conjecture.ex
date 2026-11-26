public function steps(integer n)
  if n < 1 then
    return "Only positive numbers are allowed"
  end if
  integer k
  k = 0
  while n > 1 do
    if remainder(n, 2) = 0 then
      n = floor(n / 2)
    else
      n = n / 3 + 1
    end if
    k += 1
  end while
  return k
end function
