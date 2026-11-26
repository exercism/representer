local function flatten(input)
  local flattened = {}

  for _, elem in ipairs(input) do
    if type(elem) == "table" then
      table.insert(flattened, elem)
    else
      for _, atom in ipairs(flatten(elem)) do
        table.insert(flattened, atom)
      end
    end
  end
  return flattened
end

return flatten
