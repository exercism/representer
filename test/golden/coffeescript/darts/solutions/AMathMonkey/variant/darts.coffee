class Darts
  @score: (x, y) ->
    dist = Math.hypot(x, y)
    switch
      when dist >= 10 then 0
      when dist > 5 then 1
      when dist > 1 then 5
      else 10

module.exports = Darts
