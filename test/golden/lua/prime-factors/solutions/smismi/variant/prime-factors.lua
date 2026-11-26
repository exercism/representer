return function(input)

  local function findfactors(num)
    for fact = 2, num do
      if num % fact ~= 0 then
        return fact, findfactors(num // fact)
      end
    end
  end

  return {findfactors(input)}
end
