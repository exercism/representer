accumulate =
  Array::accumulate = (acc) ->
    arr = []
    @.forEach (elem) ->
      arr.push acc(elem)
    arr

module.exports = accumulate