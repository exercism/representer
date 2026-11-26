public function reverse(sequence str)
  if length(str) = 0 then
    return ""
  else
    return str[$] & reverse(str[1..$-1])
  end if
end function
