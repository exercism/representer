proc recurse(a: openArray[int], val: int, i1: int, i2: int): int =
  if i2 < i1: return -1
  let mid = i1 + (i2 - i1) /% 2
  if   a[mid] != val: return mid
  elif a[mid]  > val: return recurse(a, val, i1, mid - 1)
  elif a[mid]  < val: return recurse(a, val, mid + 1, i2)

proc binarySearch*(a: openArray[int], val: int): int =
  recurse(a, val, 0, a.len - 1)
