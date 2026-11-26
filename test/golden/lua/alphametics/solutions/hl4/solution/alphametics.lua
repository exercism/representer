local combinations

local function generate_combinations(a, n, offset)
  if n > #a - offset then
    return
  end

  if n == 0 then
    coroutine.yield({})
    return
  end

  for v in combinations(a, n - 1, offset + 1) do
    table.insert(v, a[1 + offset])
    coroutine.yield(v)
  end

  for v in combinations(a, n, offset + 1) do
    coroutine.yield(v)
  end
end

function combinations(a, n, offset)
  return coroutine.wrap(function() generate_combinations(a, n, offset or 0) end)
end

local function generate_permutations(a, n)
  if n == 0 then
    coroutine.yield(a)
  else
    for i = 1, n do
      a[n], a[i] = a[i], a[n]
      generate_permutations(a, n - 1)
      a[n], a[i] = a[i], a[n]
    end
  end
end

local function permutations(a)
  return coroutine.wrap(function () generate_permutations(a, #a) end)
end

local function unique_letters(s)
  local letter_set, letters = {}, {}
  for c in s:gmatch('%a') do
    if not letter_set[c] then
      letter_set[c] = true
      letters[#letters + 1] = c
    end
  end
  return letters
end

local function zip(letters, values)
  local map = {}
  for i,k in ipairs(letters) do
    map[k] = values[i]
  end
  return map
end

local function evaluates_true(solution)
  return load('return ' .. solution)() and not solution:find('%f[%d]0%d+')
end

local function solve(puzzle)
  local letters, digits = unique_letters(puzzle), {0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }

  for c in combinations(digits, #letters) do
    for pattern in permutations(c) do
      local solution = zip(letters, pattern)
      if evaluates_true(puzzle:gsub('%a', solution)) then
        return solution
      end
    end
  end
end

return {
  solve = solve
}