return function(n)

  local function numberIsPrime(input)
    for i = 2, math.sqrt(input) do
      if input % i == 0 then
        return false
      end
    end
    return true
  end

  local counter = 0
  local currentNumber = 1
  if n > 0 then
    while counter < n do
      currentNumber = currentNumber + 1
      if numberIsPrime(currentNumber) then
        counter = counter + 1 
      end
    end
    return currentNumber
  else
    return error()
  end
end