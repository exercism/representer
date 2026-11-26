(num) ->
  res = 0
  while num > 0
    num -= num & -num
    res += 1
  res
