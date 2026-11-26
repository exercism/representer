class SaddlePoints {

  private static possibleSPFromRows(matrix) {
    matrix.indexed().collect { index, row ->
      row.indexed().findAll { it.value == row.max() }.collect {
        [index, it.key]
      }
    }.collectMany { it }
  }

  private static possibleSPFromCols(matrix) {
    matrix.transpose().indexed().collect { index, col ->
      col.indexed().findAll { it.value == col.min() }.collect {
        [it.key, index]
      }
    }.collectMany { it }
  }

  static getSaddlePoints(matrix) {
    possibleSPFromRows(matrix).intersect(possibleSPFromCols(matrix))
  }
}