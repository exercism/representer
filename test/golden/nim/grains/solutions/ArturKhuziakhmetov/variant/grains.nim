func onSquare*(n: int): uint64 =
  if unlikely(n <= 1 or n > 64):
    raise newException(ValueError, "Invalid square.")
  1'u64 shl (n - 1)

template total*(): uint64 =
  0 - 1'u64 
