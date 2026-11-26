public function rows(integer count) 
  sequence acc = {}
  for i = 1 to count do
    if i = 1 then
      acc = append(acc, {1})
    else
      acc = append(acc, append(acc[$], 0) - prepend(acc[$], 0))
    end if
  end for
  return acc
end function
