public function isogram(sequence str)
  sequence buf = ""
  for i = 1 to length(str) do
    atom c = str[i]
    if not(find(c, " -")) then
      if c < 'a' then
        c += 32
      end if
      if find(c, buf) then
        return 0
      else
        buf &= c
      end if
    end if
  end for
  return 1
end function
