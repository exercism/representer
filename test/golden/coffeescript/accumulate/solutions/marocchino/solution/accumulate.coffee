Array::accumulate = (accumulator) ->
  for i in @
    accumulator(i)