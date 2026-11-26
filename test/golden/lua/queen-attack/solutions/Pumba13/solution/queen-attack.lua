return function(pos)
  if pos.row < 0 or pos.row > 7 or pos.column < 0 or pos.column > 7 then
    error("Position out of bounds")
  end

  local queen = {
    row = pos.row,
    column = pos.column
  }

  function queen.can_attack(other)
    return queen.row == other.row or
           queen.column == other.column or
           (queen.row + queen.column == other.row + other.column) or
           (queen.row - queen.column == other.row - other.column)
  end

  return queen
end