public function reverse(sequence str)
  sequence result = {}
  for i = length(str) to 1 by -1 do
    result = result & str[i]
  end for
  return result
end function
