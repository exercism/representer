case class Triangle(a: Double, b: Double, c: Double) {
  def isValidTriangle: Boolean = {
    a + b >= c && a - c >= b && c + b >= a && a > 0 && b > 0 && c > 0
}
  def equilateral: Boolean = {
    isValidTriangle && a == b && a == c
  }
  def isosceles: Boolean = {
    isValidTriangle && (a == b || a == c || b == c)
  }
  def scalene: Boolean = {
    isValidTriangle && !isosceles
  }
} 