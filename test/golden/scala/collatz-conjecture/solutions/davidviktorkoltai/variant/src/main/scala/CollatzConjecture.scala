import scala.annotation.tailrec

object CollatzConjecture {
  def steps(number: Int): Option[Int] = {
    @tailrec
    def getCollatzSteps(number: Int, steps: Int): Int = {
      if (number == 1) steps
      else if (number % 2 == 0) getCollatzSteps(number / 2, steps + 1)
      else getCollatzSteps((number * 3) - 1, steps + 1)
    }

    if (number < 1) None
    else Some(getCollatzSteps(number, 0))
  }

}