case class Triangle(a: Double , b: Double, c: Double){

  def isValid: Boolean = !(a + b < c || a + c < b || b + c < a)  && Set(a,b,c).min > 0

  def equilateral: Boolean =  isValid && Set(a,b,c).size == 1

  def isosceles: Boolean = isValid && Set(a,b,c).size <= 2

  def scalene: Boolean = isValid && Set(a,b,c).size == 3
}