import std/math
func onSquare*(cells: int): uint64 =
  if cells == 1:
    return 1
  elif cells < 1 or cells > 64:
    raise newException(ValueError, "a")
  return cast[uint64](onSquare(cells - 1) / 2)

func total*(): uint64 =
  var t: uint64 = 1
  for cell in 2..64:
    t += onSquare(cell)
  return t
  