include std/search.e

public function square(integer n)
  if not is_in_range(n, {1, 64}) then return "square must be between 1 and 64" end if
  return power(2, n - 1)
end function

public function totalgrains()
  atom result = 0
  for i = 1 to 64 do
    result += square(i)
  end for
  return result
end function
