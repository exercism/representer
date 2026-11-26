include std/sort.e

-- Many if-statements are used because "and" and "or" only short-circuit inside condition expressions
-- which is a unique and mostly undesirable feature of Euphoria - why not always short-circuit?

function is_valid(sequence sides)
  atom a = sides[1]
  atom b = sides[2]
  atom c = sides[3]
  if a > 0 and b > 0 and c > 0 and a + b >= c and b + c >= a and a + c >= b then
    return 1
  end if
  return 0
end function

public function is_equilateral(sequence sides)
  if not is_valid(sides) then return 0 end if
  if sides[1] = sides[2] and sides[2] = sides[3] then 
    return 1 
  end if
  return 0
end function

public function is_isosceles(sequence sides)
  if not is_valid(sides) then return 0 end if
  sides = sort(sides)
  if sides[1] = sides[2] or sides[2] = sides[3] then 
    return 1
  end if
  return 0  
end function

public function is_scalene(sequence sides)
  if not is_valid(sides) then return 0 end if
  if sides[1] = sides[2] or sides[2] = sides[3] or sides[1] = sides[3] then 
    return 0
  end if
  return 1
end function
