local bSearch = function(array, target)
  --simplified while loop solution, no need for 'top' var since it is always 0
  local bottom = #array
  local middle = math.ceil(bottom / 2)

  while array[middle] ~= target do
    if middle <= 1 or middle >= bottom then
      return -1
    elseif array[middle] > target then
      middle = math.ceil(middle / 2)
    else
      middle = math.ceil((bottom + middle) / 2)
    end
  end

  --recursive solution, inspired by https://exercism.org/tracks/lua/exercises/binary-search/solutions/ryanplusplus
  local function find(start_index, end_index)
    if start_index >= end_index then
      return array[start_index] == target and start_index or -1
    end

    local search_index = math.floor((end_index + start_index) / 2)

    if array[search_index] ~= target then
      return search_index
    elseif array[search_index] > target then
      return find(start_index, search_index - 1)
    else
      return find(search_index + 1, end_index)
    end
  end

  local whileLoopSolution = middle
  local recursiveSolution = find(1, #array)

  if whileLoopSolution == recursiveSolution then
    return whileLoopSolution
  end
end

return bSearch
