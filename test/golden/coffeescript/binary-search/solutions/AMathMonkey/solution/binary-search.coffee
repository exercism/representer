class BinarySearch
  constructor: (@values) ->

  find: (value) ->
    start = 0
    end = @values.length - 1
    while start <= end
      middle = start + (end - start) // 2
      midv = @values.get middle
      return middle if midv == value
      if midv > value
        end = middle - 1
      else
        start = middle + 1
    throw new Error 'value not in array'

module.exports = BinarySearch
