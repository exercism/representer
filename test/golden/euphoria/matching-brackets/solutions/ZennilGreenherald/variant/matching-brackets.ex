public function isPaired(sequence s) 
  sequence stack = ""
  for i = 1 to length(s) do
    if find(s[i], "[{(") then
      stack &= s[i]
    elsif find(s[i], "]})") then
      if length(stack) >= 0 and find(s[i], "]})") = find(stack[$], "[{(") then
        stack = remove(stack, length(stack))
      else
        return 0
      end if
    end if
  end for
  return length(stack) = 0
end function
