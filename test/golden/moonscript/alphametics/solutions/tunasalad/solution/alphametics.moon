get_points_and_heads = (puzzle) ->
  points = {}
  last_group = {}
  is_head = {}

  add_points = (group, mult) ->
    for c, x in pairs last_group
      points[c] = (points[c] or 0) + x * mult

  for s in puzzle\gmatch '%w+'
    add_points last_group, 1
    group = {}
    n = s\len!
    d = 1
    for i = n, 1, -1
      c = s\sub i, i
      group[c] = (group[c] or 0) + d
      d *= 10
    is_head[s\sub 1, 1] = true
    last_group = group
  add_points last_group, -1
  points, is_head

solve_points = (points, no_zero) ->
  chars = {}
  for c, _ in pairs points
    table.insert chars, c
  return nil if #chars > 10

  digits = [ i for i = 0, 9 ]
  ans = {}
  rec = (i, j, sum) ->
    if i == 0
      return sum == 0
    c = chars[i]
    p = points[c]
    for k = 1, j
      a = digits[k]
      continue if a == 0 and no_zero[c]
      digits[k] = digits[j]
      if rec(i - 1, j - 1, sum + a * p)
        ans[c] = a
        return true
      digits[k] = a
    
  rec(#chars, 10, 0) and ans

{
  solve: (puzzle) ->
    points, no_zero = get_points_and_heads puzzle
    solve_points points, no_zero
}
