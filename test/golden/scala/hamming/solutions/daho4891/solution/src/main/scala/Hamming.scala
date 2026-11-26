import scala.annotation.tailrec

object Hamming {

  def distance(s1: String, s2: String): Option[Int] = {

    //Old code
//    @tailrec
//    def calcDist(s1: String, s2: String, acc: Int = 0): Int = {
//      if (s1.isEmpty)
//        acc
//      else {
//        if (s1.head == s2.head)
//          calcDist(s1.tail, s2.tail, acc)
//        else calcDist(s1.tail, s2.tail, acc + 1)
//      }
//    }

    if (s1.length != s2.length)
      None
    else {
      //Old code
      //Some(calcDist(s1, s2))
      Some(s1.zip(s2).count(t => t._1 != t._2))
    }
  }
}