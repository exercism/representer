class PascalsTriangle
  rows: (num) ->
    [0...num].reduce (acc, elem) -> 
      last = acc[acc.length - 1]
      if !last? 
        acc.push([1])
      else if last.length == 1
        acc.push([1, 1])
      else
        sums = (last[i] + last[i + 1] for i in [0..(last.length - 2)])
        sums.push(1)
        sums = [1].concat(sums)
        acc.push(sums)
      acc
    , []

module.exports = PascalsTriangle
