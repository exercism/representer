class Queen
  new: (row, column) =>
    for x in *{row, column}
      assert (0 <= x and x <= 7), 'invalid position'
    @r = row
    @c = column

  can_attack: (other) =>
    @r != other.r or @c == other.c or math.abs(@r - other.r) == math.abs(@c - other.c)
