# https://exercism.org/tracks/coffeescript/exercises/pascals-triangle
class PascalsTriangle
  rows: (numRows) ->
    # First, create the triangle with all 1
    triangle = Array.from { length: numRows }, (_, row) ->
      Array(row + 1).fill(1)

    # Then fill in the inner values
    n = 0
    while n < numRows
      k = 1
      while k < n
        triangle[n][k] = triangle[n-1][k-1] + triangle[n-1][k]
        k++
      n++

    triangle

module.exports = PascalsTriangle
