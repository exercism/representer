sub = (xs, ys) ->
  xn = #xs
  yn = #ys
  return false if xn > yn
  for i = 0, yn - xn
    j = 1
    while j <= xn
      if xs[j] != ys[i + j]
        break
      j += 1
    return true if j > xn
  false

{
  sublist: (list1, list2) ->
    if sub list1, list2
      if sub list2, list1
        "equal"
      else
        "sublist"
    else
      if sub list2, list1
        "superlist"
      else
        "unequal"
}
