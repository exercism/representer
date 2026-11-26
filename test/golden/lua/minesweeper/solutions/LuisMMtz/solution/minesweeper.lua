local function transform(minefield)
  local function count_mines(diagram, row, col, row_num, col_num)
    local mine_count = 0
    local count = 1
    for i = -1, 1 do
      for j = -1, 1 do
        if i == 0 and j == 0 then
          goto continue
        end
        local neighbor_row = row + i
        local neighbor_col = col + j
        if neighbor_row > 1 and neighbor_row < row_num and neighbor_col > 1 and neighbor_col < col_num then
          if diagram[neighbor_row]:sub(neighbor_col, neighbor_col) == '*' then
            mine_count = mine_count + 1
          end
        end
        ::continue::
      end
    end
    return mine_count
  end
  local row_num = #minefield
  local col_num = #minefield[1]
  local result = {}
  for i = 1, row_num do
    result[i] = {}
    for j = 1, col_num do
      local char = minefield[i]:sub(j, j)
      if char == ' ' or char == '*' or char == '-' or char == '|' or char == '+' then
        result[i][j] = char
      else
        error("Invalid character")
      end
    end
  end
  for i = 2, row_num - 1 do
    for j = 2, col_num - 1 do
      if minefield[i]:sub(j, j) == ' ' then
        local mines = count_mines(minefield, i, j, row_num, col_num)
        if mines > 0 then
          result[i][j] = tostring(mines)
        end
      end
    end
  end
  for i = 1, row_num do
    local row = table.concat(result[i])
    result[i] = row
  end
  return result
end


return { transform = transform }
