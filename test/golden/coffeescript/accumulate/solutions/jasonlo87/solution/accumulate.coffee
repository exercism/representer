Array.prototype.accumulate = (opFunc) ->
  result = []
  for x, idx in this
    result[idx] = opFunc x
  return result