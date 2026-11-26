import scala.math.pow

object ArmstrongNumbers {
  def isArmstrongNumber(n: Int): Boolean = {
    val l = digitList(n)
    n == l.map(pow(_, l.length)).sum
  }

  def digitList(n: Int): List[Int] = {
    if (n < 10) List(n) else {
      val digit = n % 10
      digitList(n / 10) :+ digit
    }
  }
}
