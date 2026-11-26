include std/utils.e

public function distance(sequence left, sequence right)
  integer result
  if length(left) != length(right) then
    return "left and right strands must be of equal length"
  end if
  result = 0
  for i = 1 to length(left) do
    result += iif(left[i] = right[i], 0, 1)
  end for
  return result
end function