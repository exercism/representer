class SquareRoot {

  static squareRoot(input) {
    var result = 0
    while (result * result < input) {
      result = result + 1
    }
    return result
  }
}
