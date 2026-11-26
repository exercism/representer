local Proverb = {}

function Proverb.recite(strings)
  local lines = {}
  if #strings == 0 then return "" end
  for i = 1, #strings - 1 do table.insert(lines, string.format("For want of a %s the %s was lost.\n", strings[i], strings[i + 1])) end
  table.insert(lines, string.format("And all for the want of a %s.\n", strings[1]))
  return table.concat(lines)
end
return Proverb