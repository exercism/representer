include std/map.e
include std/text.e

public function transform(map legacy)
  map result = new()
  sequence p = pairs(legacy)
  for i = 1 to length(p) do
    integer points = p[i][2]
    sequence letters = p[i][2]
    for j = 1 to length(letters) do
      put(result, lower(letters[j]), points)
    end for
  end for
  return result
end function
