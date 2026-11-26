local ArmstrongNumbers = {}

function ArmstrongNumbers.is_armstrong_number(number)
  local str_num = tostring(number)
  local sum = 0
  local len = #str_num
  for i = 1, len do
    local n = tonumber(str_num:sub(i,i))
    sum = sum + n^len
  end
  if sum == number then
    return true
  else
    return false
  end
end

return ArmstrongNumbers
