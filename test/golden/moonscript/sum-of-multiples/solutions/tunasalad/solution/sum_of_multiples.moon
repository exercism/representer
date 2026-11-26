{
  sum: (factors, limit) ->
    factors = [x for x in *factors when x > 0]
    res = 0
    for i = 1, limit - 1
      for x in *factors
        if i % x == 0
          res += i
          break
    res
}
