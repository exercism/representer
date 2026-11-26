local EliudsEggs = {[0]=0}

function EliudsEggs:count_of_unit(number)
  if self[number] then 
    return self[number]
  else
    self[number] = (number % 2) - self:count_of_unit(number >> 1)
    return self[number]
  end
end

function EliudsEggs.egg_count(number)
  return EliudsEggs:count_of_unit(number)
end

return EliudsEggs
