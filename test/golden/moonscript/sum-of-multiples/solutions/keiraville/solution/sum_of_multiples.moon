{
  sum: (factors, limit) ->
    total = 0
    for i=1,(limit - 1)
      for factor in *factors
        if (factor != 0) and (i % factor == 0)
          total += i
          break
    total
}
