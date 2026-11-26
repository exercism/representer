include std/convert.e

constant MAPPINGS = {
  {3, "Pling"},
  {5, "Plang"},
  {7, "Plong"}
}

public function raindrops(atom n)
  sequence result = ""
  for i = 1 to length(MAPPINGS) do
    if remainder(n, MAPPINGS[i][1]) = 0 then
      result &= MAPPINGS[i][2]
    end if
  end for
  if length(result) then
    return result
  else
    return to_string(n)
  end if
end function
