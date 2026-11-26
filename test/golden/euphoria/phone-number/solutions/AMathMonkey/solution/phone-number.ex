public function clean(sequence phrase)
  sequence filtered = ""
  for i = 1 to length(phrase) do
    if phrase[i] >= '0' and phrase[i] <= '9' then
      filtered = append(filtered, phrase[i])
    end if
  end for
  integer len = length(filtered)
  if len < 10 or len > 11 then return 0 end if
  if len = 11 then
    if filtered[1] != '1' then return 0 end if
    filtered = filtered[2..$]
  end if
  if filtered[1] <= '1' or filtered[4] <= '1' then return 0 end if
  return filtered
end function
