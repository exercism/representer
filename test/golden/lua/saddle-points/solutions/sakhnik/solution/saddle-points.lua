---@params matrix [ [integer ] ]
---@return [{row: integer, column: integer}]
return function(matrix)
  local max = {}
  local min = {}
  for row, rowTrees in ipairs(matrix) do
    for col, height in ipairs(rowTrees) do
      if not max[row] or height > max[row] then max[row] = height end
      if not min[col] or height < min[col] then min[col] = height end
    end
  end

  local r = {}
  for row, rowTrees in ipairs(matrix) do
    for col, height in ipairs(rowTrees) do
      if height == max[row] and height == min[col] then
        r[#r+1] = {row = row, column = col}
      end
    end
  end
  return r
end
