object DifferenceOfSquares {

  def sumOfSquares(n: Int): Int = {
    (1 to n).map(n => n * n).sum
  }

  def squareOfSum(n: Int): Int = {
    val sum = (1 to n).sum
    sum * sum
  }

  def differenceOfSquares(n: Int): Int = squareOfSum(n) - sumOfSquares(n)
}
